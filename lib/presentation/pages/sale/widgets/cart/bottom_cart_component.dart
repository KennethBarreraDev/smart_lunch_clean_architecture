import 'package:flutter/material.dart';

import 'package:smart_lunch/core/base_widgets/buttons/rounded_button.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class BottomCartComponent extends StatelessWidget {
  const BottomCartComponent({
    super.key,
    required this.loading,
    required this.cart,
    required this.totalPrice,
    required this.totalProducts,
    required this.validateSale,
  });

  final bool loading;
  final Map<int, int> cart;
  final double totalPrice;
  final int totalProducts;
  final VoidCallback? validateSale;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.total_price,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: "Comfortaa",
                    color: Colors.black26,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 20.0,
                          fontFamily: "Outfit",
                        ),
                        text: "\$$totalPrice",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 220,
            child: loading
                ? RoundedButton(
                    color: AppColors.orange,
                    iconData: Icons.shopping_cart,
                    text:
                        "${AppLocalizations.of(context)!.verifying_message}...",
                    verticalPadding: 14,
                    mainAxisAlignment: MainAxisAlignment.center,
                    enabled: cart.isNotEmpty,
                    onTap: () async {},
                  )
                : RoundedButton(
                    color: AppColors.orange,
                    iconData: Icons.shopping_cart,
                    text:
                        "${AppLocalizations.of(context)!.view_cart} ( $totalProducts )",
                    verticalPadding: 14,
                    mainAxisAlignment: MainAxisAlignment.center,
                    enabled: cart.isNotEmpty,
                    onTap: () async {
                      validateSale?.call();
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
