import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_lunch/core/base_widgets/products/product_category_viewer.dart';
import 'package:smart_lunch/core/base_widgets/products/sale_tab_content.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/number_utils.dart';
import 'package:smart_lunch/data/models/product_category_model.dart';
import 'package:smart_lunch/data/models/product_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class ProductsViewerList extends StatelessWidget {
  ProductsViewerList({
    super.key,
    required this.categories,
    required this.cart,
    required this.products,
    required this.addItem,
    required this.removeItem,
    required this.loadProducts,
    required this.isPresale,
    required this.bottomSaleCard,
  });

  final List<ProductCategory> categories;
  final Map<int, int> cart;
  final List<ProductModel> products;
  final void Function(ProductModel) addItem;
  final void Function(ProductModel) removeItem;
  final VoidCallback loadProducts;
  final bool isPresale;
  final Widget? bottomSaleCard;

  @override
  Widget build(BuildContext context) {
    print("Categories $categories");
    print("Products $products");
    return DefaultTabController(
      length: categories.length + 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductCategoryViewer(categories: categories),

                  const SizedBox(height: 12),
                  Expanded(
                    child: TabBarView(
                      children: [
                        RefreshIndicator(
                          onRefresh: () async {
                            loadProducts();
                          },
                          child: SaleTabContent(
                            numberFormat: NumberUtils.numberFormat,
                            cart: cart,
                            products: products,
                            addItem: addItem,
                            removeItem: removeItem,

                            isPresale: isPresale,
                          ),
                        ),

                        ...categories
                            .map(
                              (category) => RefreshIndicator(
                                onRefresh: () async {
                                  loadProducts();
                                },
                                child: SaleTabContent(
                                  numberFormat: NumberUtils.numberFormat,
                                  cart: cart,
                                  products: products
                                      .where(
                                        (product) =>
                                            product.category == category.id,
                                      )
                                      .toList(),
                                  addItem: addItem,
                                  removeItem: removeItem,

                                  isPresale: isPresale,
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                  bottomSaleCard ?? SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
