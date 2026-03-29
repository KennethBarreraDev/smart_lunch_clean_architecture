import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/topup/topup_bloc.dart';
import 'package:smart_lunch/blocs/topup/topup_event.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/blocs/users/users_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/buttons/rounded_button.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/data/models/topup_settings.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class DebtorsChildrenPage extends StatelessWidget {
  const DebtorsChildrenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TransparentScaffold(
      selectedOption: "Hijos",
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                CustomAppBar(
                  height: 20.h,
                  showDrawer: false,
                  showPageTitle: true,
                  pageTitle: "Hijos",
                  image: AppImages.appBarShortImg,
                  titleAlignment: Alignment.centerLeft,
                ),

                Column(
                  children: [
                    const SizedBox(height: 150),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.user_message,
                            style: const TextStyle(
                              fontFamily: "Comfortaa",
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.current_debt,
                            style: const TextStyle(
                              fontFamily: "Comfortaa",
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),

                    BlocBuilder<UsersBloc, UsersState>(
                      builder: (context, usersState) {
                        if (usersState is! UsersLoaded) {
                          return SizedBox.shrink();
                        }
                        return Expanded(
                          child: ListView(
                            shrinkWrap: false,
                            padding: EdgeInsets.zero,
                            children: usersState.debtUsers
                                .map(
                                  (child) => Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 15,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.15,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image:
                                                          (child.picture ?? "")
                                                              .isNotEmpty
                                                          ? NetworkImage(
                                                              child.picture ??
                                                                  "",
                                                            )
                                                          : AssetImage(
                                                                  AppImages
                                                                      .defaultProfileStudentImage,
                                                                )
                                                                as ImageProvider<
                                                                  Object
                                                                >,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${child.firstName} ${child.lastName}",
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.darkBlue,
                                                        fontSize: 16,
                                                        fontFamily: "Comfortaa",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(
                                                        context,
                                                      )!.registration,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: "Comfortaa",
                                                        color:
                                                            AppColors.darkBlue,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "\$${usersState.children.any((e) => e.user?.id == child.id) ? usersState.children.firstWhere((e) => e.user?.id == child.id).debt ?? 0.0 : 0.0}",
                                              style: TextStyle(
                                                color: AppColors.darkBlue,
                                                fontSize: 25,
                                                fontFamily: "Comfortaa",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Divider(
                                          color: AppColors.darkBlue.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 21),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    ),
                    BlocBuilder<UsersBloc, UsersState>(
                      builder: (context, usersState) {
                        if (usersState is! UsersLoaded) {
                          return SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.total_debt,
                                style: const TextStyle(
                                  fontFamily: "Comfortaa",
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                              ),
                              Text(
                                "\$${usersState.totalDebt}",
                                style: const TextStyle(
                                  fontFamily: "Comfortaa",
                                  fontSize: 25,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "* ${AppLocalizations.of(context)!.pay_debt_explanation}",
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: "Comfortaa",
                          color: AppColors.darkBlue.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    BlocBuilder<CafeteriaBloc, CafeteriaState>(
                      builder: (context, cafeteriaState) {
                        if (cafeteriaState is! CafeteriaSuccess) {
                          return SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.all(10.0),
                          child: RoundedButton(
                            color: AppColors.tuitionGreen,
                            iconData: Icons.payments,
                            text: "Pagar",
                            verticalPadding: 14,
                            mainAxisAlignment: MainAxisAlignment.center,
                            onTap: () {
                              final TopupSettings topupSettings =
                                  CafeteriaConstants.getTopupSetting(
                                    cafeteriaState.cafeteriaSettings!,
                                    cafeteriaState.selected!,
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
                                AppRoutes.getCleanRouteName(
                                  AppRoutes.topupPage,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
