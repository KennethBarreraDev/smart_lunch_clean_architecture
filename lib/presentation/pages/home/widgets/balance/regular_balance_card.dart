import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:smart_lunch/blocs/topup/topup_bloc.dart';
import 'package:smart_lunch/blocs/topup/topup_event.dart';
import 'package:smart_lunch/core/base_widgets/buttons/circled_icon.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/cafeteria_setting_model.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/topup_settings.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/home/widgets/balance/balance_label.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class RegularBalanceCard extends StatelessWidget {
  RegularBalanceCard({
    super.key,
    required this.cafeteriaUser,
    required this.cafeteria,
    required this.cafeteriaSetting,
    required this.balance,
    required this.hasDebt,
    required this.hasLowBalance,
  });

  CafeteriaUser? cafeteriaUser;
  Cafeteria? cafeteria;
  CafeteriaSetting? cafeteriaSetting;
  double balance;
  bool hasDebt;
  bool hasLowBalance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.home,
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0,
                  fontFamily: "Comfortaa",
                ),
              ),
              Text(
                DateFormat("EEEE, d MMM, yyyy", "es").format(DateTime.now()),
                style: TextStyle(
                  color: AppColors.darkBlue.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w300,
                  fontSize: 8.0,
                  fontFamily: "Comfortaa",
                ),
              ),
            ],
          ),
          Divider(color: AppColors.dividerColors),

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BalanceLabel(
                    hasDebt: hasDebt,
                    hasLowBalance: hasLowBalance,
                    balance: balance,
                    cafeteria: cafeteria,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final TopupSettings topupSettings =
                          CafeteriaConstants.getTopupSetting(
                            cafeteriaSetting!,
                            cafeteria!,
                          );
                      context.read<TopupBloc>().add(
                        ConfigureTopupEvent(
                          minimunRechargeAmount: topupSettings.minimunRechargeAmount,
                          selectedRechargeAmount: topupSettings.selectedRechargeAmount,
                          commissionFee: topupSettings.commissionFee,
                          processingTopup: false,
                          chargeCommissionToParent: topupSettings.chargeCommissionToParent,
                          commissionType: topupSettings.commissionType,
                        ),
                      );
                      context.pushNamed(
                        AppRoutes.getCleanRouteName(AppRoutes.topupPage),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircledIcon(
                          color: Color(0xff008891),
                          iconData: Icons.payments,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Text(
                            AppLocalizations.of(context)!.top_up,
                            style: const TextStyle(
                              color: Color(0xff008891),
                              fontSize: 8.0,
                              fontFamily: "Comfortaa",
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
