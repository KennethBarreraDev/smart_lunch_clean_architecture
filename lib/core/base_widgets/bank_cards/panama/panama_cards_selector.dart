import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/croem/croem_bloc.dart';
import 'package:smart_lunch/blocs/croem/croem_state.dart';
import 'package:smart_lunch/blocs/memberships/memberships_bloc.dart';
import 'package:smart_lunch/blocs/memberships/memberships_event.dart';
import 'package:smart_lunch/blocs/memberships/memberships_state.dart';
import 'package:smart_lunch/blocs/session/session_bloc.dart';
import 'package:smart_lunch/blocs/session/session_state.dart';
import 'package:smart_lunch/blocs/topup/topup_bloc.dart';
import 'package:smart_lunch/blocs/topup/topup_event.dart';
import 'package:smart_lunch/blocs/topup/topup_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/bank_cards/panama/add_card_button.dart';
import 'package:smart_lunch/core/base_widgets/bank_cards/panama/fee_component.dart';
import 'package:smart_lunch/core/base_widgets/bank_cards/panama/support_component.dart';
import 'package:smart_lunch/core/base_widgets/bank_cards/panama/yappi_button.dart';
import 'package:smart_lunch/core/base_widgets/bank_cards/select_card_component.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/base_widgets/snackbar/generic_snackbar.dart';
import 'package:smart_lunch/core/constants/countries.dart';
import 'package:smart_lunch/core/utils/allowed_topup_methods.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/membership/widgets/croem_cvv_component.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class PanamaCardsSelector extends StatelessWidget {
  PanamaCardsSelector({super.key, required this.calledFromTopup});
  bool calledFromTopup;
  final TextEditingController cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TopupBloc, TopupState>(
          listener: (context, topupState) {
            if (topupState is TopupSuccessState) {
              context.pushNamed(
                AppRoutes.getCleanRouteName(AppRoutes.topupStatus),
              );
            } else if (topupState is TopupErrorState) {
              showCustomSnackBar(
                context: context,
                bannerType: BannerTypes.errorBanner.type,
                bannerMessage: AppLocalizations.of(context)!.recharge_error,
              );
            }
          },
        ),

        BlocListener<MembershipsBloc, MembershipsState>(
          listener: (context, membershipState) {
            if (membershipState is MembershipSuccessState) {
              context.pushNamed(
                AppRoutes.getCleanRouteName(AppRoutes.membershipStatus),
              );
            } else if (membershipState is MembershipErrorState) {
              showCustomSnackBar(
                context: context,
                bannerType: BannerTypes.errorBanner.type,
                bannerMessage: AppLocalizations.of(context)!.error_membership_payment,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, sessionState) {
          if (sessionState is! SessionAuthenticated) {
            return SizedBox.shrink();
          }
          return BlocBuilder<MembershipsBloc, MembershipsState>(
            builder: (context, membershipState) {
              return BlocBuilder<TopupBloc, TopupState>(
                builder: (context, topupState) {
                  return BlocBuilder<CafeteriaBloc, CafeteriaState>(
                    builder: (context, cafeteriaState) {
                      if (cafeteriaState is! CafeteriaSuccess) {
                        return const SizedBox.shrink();
                      }
                      return BlocBuilder<CroemBloc, CroemState>(
                        builder: (context, croemState) {
                          final bool isLoading = calledFromTopup
                              ? topupState.processingTopup
                              : membershipState.loading ?? false;
                          final transactionError = calledFromTopup
                              ? topupState is TopupErrorState
                              : membershipState is MembershipErrorState;

                          final totalAmount = calledFromTopup
                              ? topupState.selectedRechargeAmount
                              : membershipState.membershipTotalPrice;

                          return TransparentScaffold(
                            selectedOption: "Inicio",
                            body: Column(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      CustomAppBar(
                                        hideGoBackText: true,
                                        titleSize: 25,
                                        height: 20.h,
                                        showPageTitle: true,
                                        pageTitle: AppLocalizations.of(
                                          context,
                                        )!.payment_method,
                                        titleAlignment: Alignment.bottomRight,
                                        image: AppImages.appBarLongImg,
                                        showDrawer: false,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 130,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 90.w,
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  20,
                                                                ),
                                                              ),
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 10,
                                                                bottom: 10,
                                                                left: 8,
                                                              ),
                                                          child: Text(
                                                            AppLocalizations.of(
                                                              context,
                                                            )!.cards_message,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      "Comfortaa",
                                                                ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 8.0,
                                                              ),
                                                          child: Divider(
                                                            color: AppColors
                                                                .darkBlue
                                                                .withValues(
                                                                  alpha: 0.2,
                                                                ),
                                                          ),
                                                        ),

                                                        ...((croemState
                                                                        as CroemCardsLoaded)
                                                                    .cards ??
                                                                [])
                                                            .map(
                                                              (
                                                                card,
                                                              ) => SelectCardComponent(
                                                                selectedCard:
                                                                    card,
                                                                onSelectCard: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (
                                                                          BuildContext
                                                                          context,
                                                                        ) {
                                                                          return Dialog(
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                20,
                                                                              ),
                                                                            ),
                                                                            child: CroemCvvComponent(
                                                                              card: card,
                                                                              cvvController: cvvController,
                                                                              paymentError: transactionError,
                                                                              totalAmont: totalAmount.toString(),
                                                                              loading: isLoading,
                                                                              cardTap: () {
                                                                                if (calledFromTopup) {
                                                                                  context
                                                                                      .read<
                                                                                        TopupBloc
                                                                                      >()
                                                                                      .add(
                                                                                        TopupBalanceEvent(
                                                                                          amount: topupState.selectedRechargeAmount.toString(),
                                                                                          userBuyer:
                                                                                              sessionState.sessionData?.userId ??
                                                                                              "",
                                                                                          cvv: cvvController.text,
                                                                                          tokenizedCard: card.tokenizedCard,
                                                                                          cardId: card.cardNumber,
                                                                                          allowedTopupMethods: AllowedPaymentMethods.croem,
                                                                                        ),
                                                                                      );
                                                                                } else {
                                                                                  context
                                                                                      .read<
                                                                                        MembershipsBloc
                                                                                      >()
                                                                                      .add(
                                                                                        PayMemberships(
                                                                                          membershipCart: membershipState.membershipCart,
                                                                                          membershipTotalPrice: membershipState.membershipTotalPrice,
                                                                                          loading: isLoading,
                                                                                          selectedMethod: AllowedPaymentMethods.croem,
                                                                                          cardID: card.cardNumber,
                                                                                          cvv: cvvController.text,
                                                                                        ),
                                                                                      );
                                                                                }
                                                                              },
                                                                            ),
                                                                          );
                                                                        },
                                                                  );
                                                                },
                                                              ),
                                                            ),

                                                        AddCardButton(
                                                          isPanama:
                                                              Countries.isPanama(
                                                                cafeteriaState
                                                                        .selected
                                                                        .school
                                                                        ?.country ??
                                                                    "",
                                                              ),
                                                          cardsAmount:
                                                              (croemState.cards ??
                                                                      [])
                                                                  .length,
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        FeeComponent(
                                                          comissionFee:
                                                              CafeteriaConstants
                                                                  .croemFee,
                                                          amount:
                                                              totalAmount ??
                                                              0.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Divider(
                                                      color: AppColors.darkBlue
                                                          .withValues(
                                                            alpha: 0.15,
                                                          ),
                                                    ),
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.orAlso,
                                                  ),
                                                  Expanded(
                                                    child: Divider(
                                                      color: AppColors.darkBlue
                                                          .withValues(
                                                            alpha: 0.15,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              YappiButton(
                                                onTap: () {
                                                  if (calledFromTopup) {
                                                    context.read<TopupBloc>().add(
                                                      TopupBalanceEvent(
                                                        amount: topupState
                                                            .selectedRechargeAmount
                                                            .toString(),
                                                        userBuyer:
                                                            sessionState
                                                                .sessionData
                                                                ?.userId ??
                                                            "",
                                                        allowedTopupMethods:
                                                            AllowedPaymentMethods
                                                                .yappi,
                                                      ),
                                                    );
                                                  } else {
                                                    context.read<MembershipsBloc>().add(
                                                      PayMemberships(
                                                        membershipCart:
                                                            membershipState
                                                                .membershipCart,
                                                        membershipTotalPrice:
                                                            membershipState
                                                                .membershipTotalPrice,
                                                        loading: isLoading,
                                                        selectedMethod:
                                                            AllowedPaymentMethods
                                                                .croem,
                                                        cardID: null,
                                                        cvv: cvvController.text,
                                                      ),
                                                    );
                                                  }
                                                },
                                                loading:
                                                    topupState.processingTopup,
                                              ),
                                              const SizedBox(height: 10),
                                              FeeComponent(
                                                comissionFee:
                                                    CafeteriaConstants.yappyFee,
                                                amount: topupState
                                                    .selectedRechargeAmount,
                                              ),
                                              const SizedBox(height: 40),
                                              SupportComponent(
                                                cafeteria:
                                                    cafeteriaState.selected,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
