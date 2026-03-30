import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/app_version/app_version_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_state.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/family/family_bloc.dart';
import 'package:smart_lunch/blocs/family/family_state.dart';
import 'package:smart_lunch/blocs/sales_history/sales_history_bloc.dart';
import 'package:smart_lunch/blocs/sales_history/sales_history_state.dart';
import 'package:smart_lunch/blocs/session/session_bloc.dart';
import 'package:smart_lunch/blocs/session/session_state.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/blocs/users/users_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/loader/main_loader.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/base_widgets/session/session_loader_builder.dart';
import 'package:smart_lunch/core/base_widgets/session/session_loader_listener.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/presentation/pages/home/widgets/balance/balance_card.dart';
import 'package:smart_lunch/presentation/pages/home/widgets/home_body/base_home_body.dart';
import 'package:smart_lunch/presentation/pages/membership/widgets/memberships_modal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppVersionBloc, AppVersionState>(
          listener: (context, state) {
            //TODO: Show version modal
            /*
            showDialog(
              context: context,
              useSafeArea: true,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const AppVersionModal();
              },
            );*/
          },
        ),

        BlocListener<UsersBloc, UsersState>(
          listener: (context, state) {
            if (state is UsersLoaded) {
              if (state.showMembershipModal) {
                showDialog(
                  context: context,
                  useSafeArea: true,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return PendingMembershipModal(
                      membershipDebtors: state.pendingUserMemberships,
                    );
                  },
                );
              }
            }
          },
        ),
      ],
      child: SessionLoadingBuilder(
        builder: (context, loading) {
          return SessionLoaderListener(
            shouldNavigate: false,
            loadOpepaySettings: false,
            onUnauthenticatedSession: () {},
            child: loading
                ? MainLoader()
                : TransparentScaffold(
                    selectedOption: "Inicio",

                    body: Stack(
                      children: [
                        BlocBuilder<CafeteriaBloc, CafeteriaState>(
                          builder: (context, state) {
                            if (state is! CafeteriaSuccess) {
                              return SizedBox();
                            }

                            return Column(
                              children: [
                                CustomAppBar(
                                  height: 35.h,
                                  showSchoolLogo: true,
                                  image: AppImages.appBarLongImg,
                                  schoolLogoUrl: state.selected.logo ?? "",
                                  schoolName: "",
                                  cafeteriaName: "${state.selected.name}",
                                ),
                              ],
                            );
                          },
                        ),

                        Column(
                          children: [
                            BlocBuilder<SessionBloc, SessionState>(
                              builder: (context, sessionState) {
                                if (sessionState is! SessionAuthenticated) {
                                  return SizedBox();
                                }
                                return BlocBuilder<
                                  CafeteriaBloc,
                                  CafeteriaState
                                >(
                                  builder: (context, cafeteriaState) {
                                    if (cafeteriaState is! CafeteriaSuccess) {
                                      return SizedBox();
                                    }
                                    return BlocBuilder<UsersBloc, UsersState>(
                                      builder: (context, userState) {
                                        if (userState is! UsersLoaded) {
                                          return SizedBox();
                                        }
                                        return BlocBuilder<
                                          FamilyBloc,
                                          FamilyState
                                        >(
                                          builder: (context, familyState) {
                                            if (familyState is! FamilyLoaded) {
                                              return SizedBox();
                                            }
                                            return BalanceCard(
                                              topMargin: 20.h,
                                              cafeteriaUser: userState.mainUser,
                                              cafeteria:
                                                  cafeteriaState.selected,
                                              cafeteriaSetting: cafeteriaState
                                                  .cafeteriaSettings,
                                              balance: familyState.balance,
                                              totalDebt: userState.totalDebt,
                                              sessionData:
                                                  sessionState.sessionData,
                                              debtors:
                                                  userState?.debtUsers ?? [],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),

                            BlocBuilder<SessionBloc, SessionState>(
                              builder: (context, sessionState) {
                                if (sessionState is! SessionAuthenticated) {
                                  return SizedBox();
                                }
                                return BlocBuilder<
                                  CafeteriaBloc,
                                  CafeteriaState
                                >(
                                  builder: (context, cafeteriaState) {
                                    if (cafeteriaState is! CafeteriaSuccess) {
                                      return SizedBox();
                                    }
                                    return BlocBuilder<UsersBloc, UsersState>(
                                      builder: (context, userState) {
                                        if (userState is! UsersLoaded) {
                                          return SizedBox();
                                        }

                                        return BlocBuilder<
                                          SalesHistoryBloc,
                                          SalesHistoryState
                                        >(
                                          builder: (context, salesState) {
                                            if (salesState
                                                is! SalesHistoryLoaded) {
                                              return SizedBox();
                                            }
                                            return Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12,
                                                    ),
                                                child: BaseHomeBody(
                                                  cafeteriaUser:
                                                      userState.mainUser,
                                                  children: userState.children,
                                                  cafeteria:
                                                      cafeteriaState.selected,
                                                  cafeteriaSetting:
                                                      cafeteriaState
                                                          .cafeteriaSettings,
                                                  sessionData:
                                                      sessionState.sessionData,
                                                  presales: salesState.presales,
                                                  dailySales: salesState.sales,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
