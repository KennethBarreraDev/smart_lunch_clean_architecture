import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/core/constants/countries.dart';
import 'package:smart_lunch/core/constants/user_roles.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/cafeteria_setting_model.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/session_data.dart';
import 'package:smart_lunch/data/models/user_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/home/widgets/balance/regular_balance_card.dart';
import 'package:smart_lunch/presentation/pages/home/widgets/balance/self_suficient_student_balance_card.dart';

class BalanceCard extends StatelessWidget {
  BalanceCard({
    super.key,
    required this.topMargin,
    required this.cafeteriaUser,
    required this.cafeteria,
    required this.cafeteriaSetting,
    required this.sessionData,
    required this.debtors,
    required this.balance,
    required this.totalDebt,
  });

  double topMargin;
  CafeteriaUser? cafeteriaUser;
  CafeteriaSetting? cafeteriaSetting;
  SessionData? sessionData;
  Cafeteria? cafeteria;
  List<UserModel> debtors;
  double balance;
  double totalDebt;
  

  @override
  Widget build(BuildContext context) {
    //TODO: Ask for a setting for minimun balance
    bool hasLowBalance =
        balance <
        (Countries.isPanama(cafeteria?.school?.country ?? "")
            ? CafeteriaConstants.minimunPanamaBalance
            : CafeteriaConstants.minimunMexicoBalance);

    double currentBalance = (balance - totalDebt);
    bool hasDebt = currentBalance < 0;
    currentBalance = currentBalance.abs();

    return _baseCard(
      context: context,
      cafeteriaUser: cafeteriaUser,
      cafeteria: cafeteria,
      cafeteriaSetting: cafeteriaSetting,
      debtors: debtors,
      balance: currentBalance,
      hasLowBalance: hasLowBalance,
      hasDebt: hasDebt,
      topMargin: topMargin,
       sessionData: sessionData,
    );
  }
}

Widget _baseCard({
  required BuildContext context,
  required CafeteriaUser? cafeteriaUser,
  required Cafeteria? cafeteria,
  required CafeteriaSetting? cafeteriaSetting,
  required List<UserModel> debtors,
  required double balance,
  required bool hasDebt,
  required bool hasLowBalance,
  required SessionData? sessionData,
  required double topMargin,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: topMargin),
        width: 90.w,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.dividerColors,
              offset: Offset(0, 6),
              blurRadius: 18,
              spreadRadius: -5,
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            (cafeteriaUser?.selfSufficient ?? false || sessionData?.userType == UserRole.teacher)
                ? SelfSuficientStudentBalanceCard(
                    cafeteriaUser: cafeteriaUser,
                    cafeteria: cafeteria,
                    cafeteriaSetting: cafeteriaSetting,
                    balance: balance,
                    hasLowBalance: hasLowBalance,
                    hasDebt: hasDebt,
                  )
                : RegularBalanceCard(
                    cafeteriaUser: cafeteriaUser,
                    cafeteria: cafeteria,
                    balance: balance,
                    hasLowBalance: hasLowBalance,
                    hasDebt: hasDebt,
                  ),

            if (hasDebt && sessionData?.userType == UserRole.tutor && debtors.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    width: 90.w,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: AppColors.coral.withValues(alpha: 0.2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.money_off, color: AppColors.coral, size: 17),

                        SizedBox(width: 6),

                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.debt_text,
                            style: TextStyle(
                              color: AppColors.coral,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.coral,
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}
