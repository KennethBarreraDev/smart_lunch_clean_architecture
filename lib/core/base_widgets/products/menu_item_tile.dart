import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_lunch/core/base_widgets/products/products_details_modal.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/data/models/product_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class MenuItemTile extends StatelessWidget {
  const MenuItemTile({
    super.key,
    required this.product,
    required this.category,
    required this.removeItems,
    required this.addItems,
    required this.numberFormat,
    required this.amount,
  });

  final ProductModel product;
  final String category;
  final void Function(ProductModel) removeItems;
  final void Function(ProductModel) addItems;
  final NumberFormat numberFormat;
  final int amount;

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width > 600 ? 40.0 : 30.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        minVerticalPadding: 12,
        leading: Container(
          width: MediaQuery.of(context).size.width * 0.15,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              fit: (product.imageUrl ?? "").isNotEmpty
                  ? BoxFit.cover
                  : BoxFit.contain,
              image: (product.imageUrl ?? "").isNotEmpty
                  ? NetworkImage(product.imageUrl ?? "")
                  : AssetImage(AppImages.defaultProductImage)
                        as ImageProvider<Object>,
            ),
          ),
        ),

        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
        horizontalTitleGap: 12,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name ?? "",
              style: TextStyle(
                color: AppColors.darkBlue,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                fontFamily: "Comfortaa",
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            Text(
              category,
              style: TextStyle(
                color: AppColors.coral.withValues(alpha: 0.75),
                fontWeight: FontWeight.w700,
                fontSize: 10,
                fontFamily: "Comfortaa",
              ),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      useSafeArea: true,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return ProductDetailsModal(
                          productImageUrl: product.imageUrl ?? "",
                          productTitle: product.name ?? "",
                          totalPrice: product.price ?? 0.0,
                          ingredients: product.ingredients ?? [],
                          productCategory: category,
                          description: product.description ?? "",
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    backgroundColor: AppColors.lightBlue.withValues(
                      alpha: 0.15,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.details,
                    style: TextStyle(
                      color: AppColors.lightBlue,
                      fontSize: 11.0,
                      fontFamily: "Comfortaa",
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "\$${numberFormat.format(product.price)}",
                    style: TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Outfit",
                    ),
                  ),
                ),
                IntrinsicWidth(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: AppColors.orange,
                        ),
                        iconSize: iconSize,
                        onPressed: () {
                          removeItems.call(product);
                        },
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "$amount",
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle, color: AppColors.orange),
                        iconSize: iconSize,
                        onPressed: () {
                          addItems.call(product);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.orange.withValues(alpha: 0.5)),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
