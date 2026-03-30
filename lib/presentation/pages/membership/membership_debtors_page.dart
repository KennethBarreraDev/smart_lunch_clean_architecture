import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/memberships/memberships_bloc.dart';
import 'package:smart_lunch/blocs/memberships/memberships_event.dart';
import 'package:smart_lunch/blocs/memberships/memberships_state.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/blocs/users/users_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/buttons/rounded_button.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/membership/widgets/student_membership_component.dart';

class MembershipDebtorsPage extends StatelessWidget {
  const MembershipDebtorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TransparentScaffold(
      selectedOption: "Inicio",
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    CustomAppBar(
                      height: 20.h,
                      showDrawer: false,
                      showPageTitle: true,
                      pageTitle: AppLocalizations.of(
                        context,
                      )!.membership_payment,
                      image: AppImages.appBarShortImg,
                      titleAlignment: Alignment.centerLeft,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      child: Column(
                        children: [
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
                                  AppLocalizations.of(context)!.amount_message,
                                  style: const TextStyle(
                                    fontFamily: "Comfortaa",
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          BlocBuilder<MembershipsBloc, MembershipsState>(
                            builder: (context, membershipsState) {
                              return BlocBuilder<UsersBloc, UsersState>(
                                builder: (context, usersState) {
                                  if (usersState is! UsersLoaded) {
                                    return SizedBox.shrink();
                                  }
                                  return Expanded(
                                    child: ListView(
                                      shrinkWrap: false,
                                      padding: EdgeInsets.zero,
                                      children: [
                                        ...(usersState.pendingUserMemberships).map(
                                          (child) => StudentMembershipComponent(
                                            image: child.user?.picture ?? "",
                                            name: child.user?.firstName ?? "",
                                            lastName:
                                                child.user?.lastName ?? "",
                                            membershipAmount:
                                                (membershipsState
                                                            .membershipCart ??
                                                        {})
                                                    .containsKey(child.id)
                                                ? ((membershipsState
                                                              .membershipCart ??
                                                          {})[child.id] ??
                                                      0)
                                                : 0,
                                            studentId: child.id ?? 0,
                                            addItems: (userID) {
                                              context
                                                  .read<MembershipsBloc>()
                                                  .add(
                                                    AddUserToMembershipToPayment(
                                                      child,
                                                    ),
                                                  );
                                            },
                                            removeItems: (userID) {
                                              context.read<MembershipsBloc>().add(
                                                RemoveUserFromMembershipPayment(
                                                  child,
                                                ),
                                              );
                                            },
                                            expiration:
                                                (child.membershipExpiration ??
                                                ""),
                                            minMembeshipAmount: 0,
                                          ),
                                        ),
                                        BlocBuilder<
                                          MembershipsBloc,
                                          MembershipsState
                                        >(
                                          builder: (context, membershipsState) {
                                            return Padding(
                                              padding: const EdgeInsets.all(
                                                12.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.subtotal,
                                                    style: const TextStyle(
                                                      fontFamily: "Comfortaa",
                                                      fontSize: 18,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: false,
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    "\$${(membershipsState.membershipTotalPrice ?? 0.0).abs().toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                      fontFamily: "Comfortaa",
                                                      fontSize: 25,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                            "* ${AppLocalizations.of(context)!.pay_membership_legend}",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontFamily: "Comfortaa",
                                              color: AppColors.darkBlue
                                                  .withValues(alpha: 0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          BlocBuilder<MembershipsBloc, MembershipsState>(
                            builder: (context, membershipsState) {
                              return Padding(
                                padding: EdgeInsets.all(10.0),
                                child: RoundedButton(
                                  color:
                                      (membershipsState.membershipCart ?? {})
                                          .isEmpty
                                      ? AppColors.darkBlue
                                      : AppColors.tuitionGreen,
                                  iconData: Icons.payments,
                                  text: "Pagar",
                                  verticalPadding: 14,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  onTap: () async {
                                    if ((membershipsState.membershipCart ?? {})
                                        .isNotEmpty) {
                                      //TODO: Load CROEM Cards
                                      
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
