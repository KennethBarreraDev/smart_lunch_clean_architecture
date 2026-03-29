import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/topup/topup_bloc.dart';
import 'package:smart_lunch/blocs/topup/topup_event.dart';
import 'package:smart_lunch/core/base_widgets/buttons/rounded_button.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/cafeteria_setting_model.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/topup_settings.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/home/widgets/balance/balance_label.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class SelfSuficientStudentBalanceCard extends StatelessWidget {
  SelfSuficientStudentBalanceCard({
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
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 20.w,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: (cafeteriaUser?.user?.picture ?? "").isNotEmpty
                      ? NetworkImage(cafeteriaUser?.user?.picture ?? "")
                      : AssetImage(AppImages.defaultProfileStudentImage)
                            as ImageProvider<Object>,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 230,
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${cafeteriaUser?.user?.firstName} ${cafeteriaUser?.user?.lastName}",
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    AppLocalizations.of(context)!.student,
                    style: TextStyle(
                      color: AppColors.darkBlue.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w700,
                      fontSize: 10.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
        Divider(color: AppColors.dividerColors),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      AppLocalizations.of(context)!.current_balance,
                      style: TextStyle(
                        color: AppColors.orange,
                        fontWeight: FontWeight.bold,

                        fontSize: 12,
                      ),
                    ),
                  ),
                  BalanceLabel(
                    hasDebt: hasDebt,
                    hasLowBalance: hasLowBalance,
                    balance: balance,
                    cafeteria: cafeteria,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: (cafeteriaSetting?.openpayRecharge ?? false)
                  ? ClipOval(
                      child: Material(
                        color: AppColors.tuitionGreen.withValues(
                          alpha: 0.2,
                        ), // Button color
                        child: InkWell(
                          onTap: () async {
                            final TopupSettings topupSettings =
                                CafeteriaConstants.getTopupSetting(
                                  cafeteriaSetting!,
                                  cafeteria!,
                                );
                            context.read<TopupBloc>().add(
                              ConfigureTopupEvent(
                                minimunRechargeAmount:
                                    topupSettings.minimunRechargeAmount,
                                selectedRechargeAmount:
                                    topupSettings.selectedRechargeAmount,
                                commissionFee: topupSettings.commissionFee,
                                processingTopup: false,
                                chargeCommissionToParent:
                                    topupSettings.chargeCommissionToParent,
                                commissionType: topupSettings.commissionType,
                              ),
                            );
                            context.pushNamed(
                              AppRoutes.getCleanRouteName(AppRoutes.topupPage),
                            );
                          },
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.add,
                              color: AppColors.tuitionGreen,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),

        Divider(color: AppColors.dividerColors),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (cafeteriaSetting?.openpayRecharge ?? false)
                ? RoundedButton(
                    color: AppColors.tuitionGreen,
                    iconData: Icons.credit_card,
                    text: AppLocalizations.of(context)!.cards_message,
                    onTap: () {},
                  )
                : SizedBox(),
            RoundedButton(
              color: AppColors.lightBlue,
              iconData: Icons.contact_emergency,
              text: AppLocalizations.of(context)!.crendential_message,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
