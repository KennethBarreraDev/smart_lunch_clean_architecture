import 'dart:convert';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:smart_lunch/core/constants/user_roles.dart';
import 'package:smart_lunch/core/http/api_urls.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
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
}
