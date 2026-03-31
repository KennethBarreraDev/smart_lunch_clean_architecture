import 'dart:convert';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:smart_lunch/core/constants/user_roles.dart';
import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/core/utils/sale_types.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/multisale_product_model.dart';
import 'package:smart_lunch/data/models/presale_model.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';

class SalesRepository {
  final ApiClientRepository api;

  SalesRepository(this.api);

  Future<List<Presale>> loadSales(CafeteriaUser currentUser) async {
    try {
      developer.log("Loading user sales from api", name: "loadSales");
      String saleType = "MO";

      if ((currentUser.selfSufficient ?? false) ||
          api.sessionRepository.session?.userType == UserRole.teacher) {
        saleType = "IM";
      } else {
        saleType = "MO";
      }

      String today = DateFormat("yyyy-MM-dd").format(DateTime.now().toUtc());

      final response = await api.get(
        "${ApiUrls.salesUrl}?page_size=100&created_at__gte=$today",
        logName: "loadSales",
      );

      if (response.statusCode != 200) {
        developer.log(
          "Failed to load sales: ${response.statusCode} - ${response.body}",
          name: "loadSales",
        );

        throw Exception("error_loading_sales");
      }

      List<dynamic> body = json.decode(
        utf8.decode(response.bodyBytes),
      )["results"];

      developer.log("Sales response $body", name: "loadSales");

      final userType = api.sessionRepository.session?.userType;
      final studentId = api.sessionRepository.session?.userId;
      List<Presale> dailySales = [];

      if ((userType == UserRole.tutor || userType == UserRole.teacher)) {
        for (dynamic saleElement in body) {
          if (saleElement["sale_type"] != "PS") {
            dailySales.add(Presale.fromJson(saleElement));
          }
        }
      } else if (userType == UserRole.student) {
        for (dynamic saleElement in body) {
          if (saleElement["user_buyer"]["instance"]["id"].toString() ==
                  studentId.toString() &&
              saleElement["sale_type"] != "PS") {
            dailySales.add(Presale.fromJson(saleElement));
          }
        }
      }

      return dailySales;
    } catch (e) {
      developer.log("Failed to load cafeterias: $e", name: "loadSales");
      throw Exception("error_loading_sales");
    }
  }

  Future<List<Presale>> loadPresales(CafeteriaUser currentUser) async {
    try {
      developer.log("Loading user sales from api", name: "LoadPresales");

      String today = DateFormat("yyyy-MM-dd").format(DateTime.now().toUtc());

      final response = await api.get(
        "${ApiUrls.salesUrl}?page_size=100&created_at__gte=$today&sale_type=PS",
        logName: "LoadPresales",
      );

      if (response.statusCode != 200) {
        developer.log(
          "Failed to load sales: ${response.statusCode} - ${response.body}",
          name: "LoadPresales",
        );
        throw Exception("error_loading_presales");
      }

      List<dynamic> body = json.decode(
        utf8.decode(response.bodyBytes),
      )["results"];

      developer.log("Presales response $body", name: "LoadPresales");

      final userType = api.sessionRepository.session?.userType;
      final studentId = api.sessionRepository.session?.userId;

      List<Presale> presales = [];

      if (userType == UserRole.tutor || userType == UserRole.teacher) {
        for (dynamic saleElement in body) {
          Presale presale = Presale.fromJson(saleElement);

          //if(presale.saleStatus!="CANCELED"){
          presales.add(presale);
          //}
        }
      } else if (userType == UserRole.student) {
        for (dynamic saleElement in body) {
          Presale presale = Presale.fromJson(saleElement);
          //presale.saleStatus!="CANCELED"
          if (saleElement["user_buyer"]["instance"]["id"].toString() ==
              studentId.toString()) {
            presales.add(presale);
          }
        }
      }
      return presales;
    } catch (e) {
      developer.log("Failed to load cafeterias: $e", name: "loadPresales");
      throw Exception("error_loading_presales");
    }
  }

  Future<Map<String, dynamic>> sellProducts({
    String? userBuyer,
    DateTime? saleDate,
    Map<int, int>? cart,
    String? comments,
    bool isPresale = false,
    bool isAutosuficientStudent = false,
    bool payWithBalance = false,
    String? cardId,
    String? deviceSessionId,
  }) async {
    try {
      developer.log("Selling products", name: "sellProducts");

      final SaleTypes saleTypeEnum = isPresale
          ? SaleTypes.PS
          : (payWithBalance ? SaleTypes.MO : SaleTypes.IM);

      final String saleType = saleTypeEnum.name;

      final List<Map<String, int>> orders = (cart ?? {}).entries
          .map((e) => {"product": e.key, "quantity": e.value})
          .toList();

      final Map<String, dynamic> data = {
        "orders": orders,
        "comment": comments,
        "user_buyer": userBuyer,
        "sale_type": saleType,
        "payment_method": payWithBalance ? "SMART_COIN" : "OPENPAY",
      };

      if (!payWithBalance) {
        data.addAll({"card_id": cardId, "device_session_id": deviceSessionId});
      }

      if (saleTypeEnum == SaleTypes.PS) {
        DateTime dateScheduledRaw = DateFormat(
          'dd/MM/yyyy',
        ).parse(saleDate.toString());
        String formattedScheduledDate = dateScheduledRaw.toUtc().toString();

        data["scheduled_date"] = formattedScheduledDate;
      } else {
        // No PS
        //Add two minutes to avoid time error
        if (!payWithBalance) {
          String formattedScheduledDate =
              DateFormat("yyyy-MM-dd'T'HH:mm:ss.'000Z'")
                  .format(
                    (saleDate ?? DateTime.now())
                        .add(const Duration(minutes: 2))
                        .toUtc(),
                  )
                  .toString();

          data["scheduled_date"] = formattedScheduledDate;
        } else {
          String formattedScheduledDate = DateFormat(
            "yyyy-MM-dd'T'HH:mm:ss.'000Z'",
          ).format(DateTime.now().toUtc()).toString();

          data["scheduled_date"] = formattedScheduledDate;
        }
      }

      developer.log(data.toString(), name: "sellProductsBody");

      final response = await api.post(
        ApiUrls.salesUrl,
        data,
        logName: "sellProducts",
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        developer.log(
          "Error selling products: ${response.statusCode} - ${response.body}",
          name: "sellProducts",
        );
        return {};
      }
      Map<String, dynamic> responseMap = json.decode(
        utf8.decode(response.bodyBytes),
      );
      developer.log(responseMap.toString(), name: "sellProducts");
      String successfulSaleId = responseMap["folio"].toString();
      String successfulSaleCharge = responseMap["final_price"].toString();
      return {"saleId": successfulSaleId, "finalPrice": successfulSaleCharge};
    } catch (e) {
      developer.log("Failed to sell products: $e", name: "sellProducts");
      return {};
    }
  }

  Future<bool> placeMultisale({
    List<MultisaleProducts>? multisaleProducts,
    String? userBuyer,
  }) async {
    try {
      List<dynamic> sales = [];

      for (MultisaleProducts date in (multisaleProducts ?? [])) {
        List<Map<String, int>> orders = [];

        if (date.cart.isNotEmpty) {
          for (MapEntry<int, int> cartItem in date.cart.entries) {
            orders.add({"product": cartItem.key, "quantity": cartItem.value});
          }

          sales.add({
            "orders": orders,
            "comment": date.comment,
            "sale_type": "DI",
            "scheduled_date": DateFormat(
              "yyyy-MM-dd'T'HH:mm:ss.'000Z'",
            ).format(date.saleDate.toUtc()),
          });
        }
      }

      Map<String, dynamic> body = {};
      body = {
        "sales": sales,
        "user_buyer": userBuyer,
        "payment_method": "SMART_COIN",
      };

      developer.log(body.toString(), name: "placeMultisaleBody");

      final response = await api.post(
        ApiUrls.mobileSales,
        body,
        logName: "placeMultisale",
      );

      developer.log(
        "Status code: ${response.statusCode}, body: ${response.body}",
        name: "placeMultisale",
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      developer.log("Failed to sell products: $e", name: "sellProducts");
      return false;
    }
  }
}
