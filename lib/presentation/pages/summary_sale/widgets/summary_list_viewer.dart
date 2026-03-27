import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/sales/sales_bloc.dart';
import 'package:smart_lunch/blocs/sales/sales_state.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/number_utils.dart';
import 'package:smart_lunch/data/models/product_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/summary_sale/widgets/cart_item_summary.dart';
import 'package:smart_lunch/presentation/pages/summary_sale/widgets/comments_modal.dart';
import 'package:smart_lunch/presentation/pages/summary_sale/widgets/custom_card_clipper.dart';

class SummaryListViewer extends StatelessWidget {
  SummaryListViewer({
    super.key,
    required this.products,
    required this.cart,
    required this.comments,
    required this.saveComments,
  });

  final List<ProductModel> products;
  final Map<int, int> cart;
  final String comments;
  final void Function(String) saveComments;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ClipPath(
        clipper: CustomCardClipper(),
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          height: 50.h,
          width: double.infinity,
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),

              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Resumen de compra",
                  style: TextStyle(
                    color: AppColors.darkBlue.withValues(alpha: 0.5),
                  ),
                ),
              ),

              Divider(color: AppColors.darkBlue.withValues(alpha: 0.2)),

              const Padding(padding: EdgeInsets.only(top: 10)),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: (products)
                      .map(
                        (product) => CartItemSummary(
                          productID: product.id ?? 0,
                          productImageUrl: product.imageUrl ?? "",
                          productName: product.name ?? "",
                          amount: cart[product.id ?? 0] ?? 0,
                          price: product.price ?? 0.0,
                          numberFormat: NumberUtils.numberFormat,
                        ),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        useSafeArea: true,
                        builder: (BuildContext context) {
                          return CommentsModal(
                            controller: controller,
                            onTap: () => {saveComments(controller.text)},
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Icon(Icons.edit_note, color: AppColors.lightBlue),
                          const SizedBox(width: 5),
                          Text(
                            AppLocalizations.of(context)!.add_comment,
                            style: TextStyle(
                              color: AppColors.lightBlue,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.comments_message,
                      style: TextStyle(
                        color: AppColors.lightBlue,
                        fontFamily: "Comfortaa",
                      ),
                    ),
                    Text(
                    comments.isEmpty ? "Sin comentarios" : comments,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Comfortaa",
                      ),
                    ),
                    const SizedBox(height: 7),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
