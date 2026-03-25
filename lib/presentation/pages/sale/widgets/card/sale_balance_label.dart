import 'package:flutter/material.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class SaleBalanceLabel extends StatelessWidget {
  SaleBalanceLabel({super.key, required this.balance});

  double balance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.available_balance,
              style: const TextStyle(
                color: Colors.black26,
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
                fontFamily: "Comfortaa",
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
                    text: "${balance < 0 ? -balance : balance}",
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
