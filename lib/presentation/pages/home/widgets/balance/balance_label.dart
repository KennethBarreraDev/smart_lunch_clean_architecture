import 'package:flutter/material.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';

class BalanceLabel extends StatelessWidget {
  BalanceLabel({
    super.key,
    required this.hasDebt,
    required this.hasLowBalance,
    required this.balance,
    required this.cafeteria,
  });
  bool hasDebt;
  bool hasLowBalance;
  double balance;
  Cafeteria? cafeteria;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            style: TextStyle(
              color: hasDebt || hasLowBalance
                  ? AppColors.coral
                  : AppColors.darkBlue,
              fontSize: 30,
              fontFamily: "Outfit",
            ),
            text: hasDebt ? "- $balance" : "$balance",
          ),
          TextSpan(
            style: TextStyle(
              color: hasDebt || hasLowBalance
                  ? AppColors.coral
                  : AppColors.darkBlue,
              fontSize: 14,
              fontFamily: "Outfit",
            ),
            text:
                cafeteria?.school?.currency ??
                CafeteriaConstants.defaultCurrency,
          ),
        ],
      ),
    );
  }
}
