import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_lunch/core/base_widgets/sale_list/order_tile.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/presale_model.dart';
class TabContent extends StatelessWidget {
  const TabContent({
    super.key,
    required this.products,
    required this.cafeteria,
    required this.isPresale,
  });

  final List<Presale> products;
  final Cafeteria? cafeteria;
  final bool isPresale;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: false,
      padding: EdgeInsets.zero,
      children: products
          .map(
            (product) => OrderTile(
              cafeteriaComment: product.cafeteriaComment,
              saleStatus: product.saleStatus,
              presaleId: product.presaleId,
              isPresale: isPresale,
              studentName: product.childName,
              studentImageUrl: product.childProfileImage,
              orderNumber: product.orderNumber,
              deliveryDate: isPresale ? product.scheduledDate : product.deliveryDate,
              totalPrice: NumberFormat("###,##0.00").format(product.saleTotal),
              products: product.products,
              cafeteria: cafeteria,
            ),
          )
          .toList(),
    );
  }
}
