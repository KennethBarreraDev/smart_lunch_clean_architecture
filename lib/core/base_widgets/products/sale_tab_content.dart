import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_lunch/core/base_widgets/products/menu_item_tile.dart';
import 'package:smart_lunch/data/models/product_model.dart';

class SaleTabContent extends StatelessWidget {
  const SaleTabContent({
    super.key,
    required this.numberFormat,
    required this.products,
    required this.addItem,
    required this.removeItem,
    required this.cart,

    required this.isPresale,
  });

  final NumberFormat numberFormat;
  final List<ProductModel> products;
  final void Function(ProductModel) addItem;
  final void Function(ProductModel) removeItem;

  final Map<int, int> cart;
  final bool isPresale;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...products.map(
            (product) => MenuItemTile(
              product: product,
              category: product.category.toString(),
              addItems: addItem,
              removeItems: removeItem,
            
              numberFormat: numberFormat,
              amount: cart.containsKey(product.id)
                  ? (cart[product.id] ?? 0)
                  : 0,
            ),
          ),
        ],
      ),
    );
  }
}
