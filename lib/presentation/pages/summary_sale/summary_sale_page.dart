import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/croem/croem_bloc.dart';
import 'package:smart_lunch/blocs/croem/croem_state.dart';
import 'package:smart_lunch/blocs/family/family_bloc.dart';
import 'package:smart_lunch/blocs/family/family_state.dart';
import 'package:smart_lunch/blocs/openpay/openpay_bloc.dart';
import 'package:smart_lunch/blocs/openpay/openpay_state.dart';
import 'package:smart_lunch/blocs/sales/sales_bloc.dart';
import 'package:smart_lunch/blocs/sales/sales_event.dart';
import 'package:smart_lunch/blocs/sales/sales_state.dart';
import 'package:smart_lunch/blocs/session/session_bloc.dart';
import 'package:smart_lunch/blocs/session/session_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/go_back_button.dart';
import 'package:smart_lunch/core/base_widgets/buttons/rounded_button.dart';
import 'package:smart_lunch/core/base_widgets/openpay/openpay_row.dart';
import 'package:smart_lunch/core/base_widgets/snackbar/generic_snackbar.dart';
import 'package:smart_lunch/core/constants/countries.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/date_utils.dart';
import 'package:smart_lunch/data/models/generic_card.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/core/base_widgets/bank_cards/empty_cards_component.dart';
import 'package:smart_lunch/core/base_widgets/bank_cards/select_card_component.dart';
import 'package:smart_lunch/presentation/pages/summary_sale/widgets/summary_list_viewer.dart';
import 'package:smart_lunch/presentation/pages/summary_sale/widgets/summary_selected_child.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class SummarySalePage extends StatelessWidget {
  const SummarySalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        if (state is! SessionAuthenticated) {
          return const SizedBox.shrink();
        }

        return BlocListener<SalesBloc, SaleState>(
          listener: (context, state) {
            if (state is SaleSuccessState) {
              if (state.isPresale) {
                context.pushNamed(
                  AppRoutes.getCleanRouteName(AppRoutes.successfulSale),
                );
              } else {
                context.pushNamed(
                  AppRoutes.getCleanRouteName(AppRoutes.successfulSale),
                );
              }
            } else if (state is SaleErrorState) {
              showCustomSnackBar(
                context: context,
                bannerType: BannerTypes.errorBanner.type,
                bannerMessage: AppLocalizations.of(context)!.try_again_later,
              );
            }
          },
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [AppColors.coral, AppColors.orange],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      _HeaderSection(),
                      SizedBox(height: 10),
                      _SummarySection(),
                      SizedBox(height: 10),
                      _PaymentSection(),
                      SizedBox(height: 10),
                      _TotalSection(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: GoBackButton(title: AppLocalizations.of(context)!.finish_purchase),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection();

  String _formatDate(SaleState state) {
    final date = state.saleDate ?? DateTime.now();

    if (state.isPresale) {
      return CustomDateUtils.formatDateWithOutMinutes(date);
    }

    if (state.scheduledHour == null) {
      return CustomDateUtils.formatDateWithOutMinutes(date);
    }

    return CustomDateUtils.formatDateWithMinutes(date);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesBloc, SaleState>(
      builder: (context, state) {
        if (state.selectedUser == null || state.saleDate == null) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            SummarySelectedChild(
              selectedUser: state.selectedUser!,
              selectedDate: _formatDate(state),
            ),
            const SizedBox(height: 10),
            SummaryListViewer(
              products: state.cartProducts ?? [],
              cart: state.cart ?? {},
              comments: state.comments ?? "",
              saveComments: (comments) {
                context.read<SalesBloc>().add(SaveComments(comments));
              },
            ),
          ],
        );
      },
    );
  }
}

class _PaymentSection extends StatelessWidget {
  const _PaymentSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CafeteriaBloc, CafeteriaState>(
      builder: (context, cafeteriaState) {
        if (cafeteriaState is! CafeteriaSuccess) {
          return const SizedBox.shrink();
        }

        final isPanama = Countries.isPanama(
          cafeteriaState.selected.school?.country ?? "",
        );

        final openpayRecharge =
            cafeteriaState.cafeteriaSettings.openpayRecharge;

        final croemState = context.select((CroemBloc bloc) => bloc.state);
        final openpayState = context.select((OpenpayBloc bloc) => bloc.state);
        final saleState = context.select((SalesBloc bloc) => bloc.state);

        final isLoading =
            croemState is CroemLoading || openpayState is OpenpayLoading;

        if (isLoading) {
          return const CircularProgressIndicator();
        }

        final shouldShow =
            openpayRecharge && !(saleState.payWithBalance ?? false);

        if (!shouldShow) {
          return const SizedBox.shrink();
        }

        final hasCards = isPanama && croemState is CroemCardsLoaded
            ? (croemState.cards ?? []).isNotEmpty
            : !isPanama && openpayState is OpenpayCardsLoaded
            ? (openpayState.cards ?? []).isNotEmpty
            : false;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.payment_method,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            hasCards
                ? SelectCardComponent(
                    selectedCard: isPanama && croemState is CroemCardsLoaded
                        ? croemState.selectedCard!
                        : !isPanama && openpayState is OpenpayCardsLoaded
                        ? openpayState.selectedCard!
                        : GenericCard(),
                    onSelectCard: () {
                      context.pushNamed(
                        AppRoutes.getCleanRouteName(AppRoutes.selectCardToPay),
                      );
                    },
                  )
                : EmptyCardsComponent(
                    onTap: () {
                      final route = isPanama
                          ? AppRoutes.registerCroemCard
                          : AppRoutes.registerOpenpayCard;

                      context.pushNamed(AppRoutes.getCleanRouteName(route));
                    },
                  ),
            if (openpayRecharge) OpenpayLogosRow(),
          ],
        );
      },
    );
  }
}

class _TotalSection extends StatelessWidget {
  const _TotalSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CafeteriaBloc, CafeteriaState>(
      builder: (context, cafeteriaState) {
        if (cafeteriaState is! CafeteriaSuccess) {
          return const SizedBox.shrink();
        }

        final isPanama = Countries.isPanama(
          cafeteriaState.selected.school?.country ?? "",
        );

        final openpayRecharge =
            cafeteriaState.cafeteriaSettings.openpayRecharge;

        final croemState = context.select((CroemBloc bloc) => bloc.state);
        final openpayState = context.select((OpenpayBloc bloc) => bloc.state);
        final saleState = context.select((SalesBloc bloc) => bloc.state);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: BlocBuilder<FamilyBloc, FamilyState>(
            builder: (context, familyState) {
              if (familyState is! FamilyLoaded) {
                return const SizedBox.shrink();
              }

              return BlocBuilder<CafeteriaBloc, CafeteriaState>(
                builder: (context, cafeteriaState) {
                  if (cafeteriaState is! CafeteriaSuccess) {
                    return const SizedBox.shrink();
                  }

                  return BlocBuilder<SalesBloc, SaleState>(
                    builder: (context, salesState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (cafeteriaState.cafeteriaSettings.openpayRecharge)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Transform.scale(
                                  scale:
                                      0.9, // Ajusta este valor para cambiar el tamaño
                                  child: Switch(
                                    value: salesState.payWithBalance ?? false,
                                    activeTrackColor: AppColors.tuitionGreen
                                        .withValues(alpha: 0.2),
                                    inactiveTrackColor: Colors.grey.withValues(
                                      alpha: 0.2,
                                    ),
                                    activeColor: AppColors.tuitionGreen,
                                    inactiveThumbColor: Colors.grey.withValues(
                                      alpha: 0.8,
                                    ),
                                    onChanged: (value) => {
                                      context.read<SalesBloc>().add(
                                        PayWithBalance(value),
                                      ),
                                    },
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${AppLocalizations.of(context)!.pay_with_balance} (\$${familyState.balance})",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          Text(
                            AppLocalizations.of(context)!.total_price,
                            style: TextStyle(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                (salesState.totalPrice ?? 0.0).toStringAsFixed(
                                  2,
                                ),
                                style: const TextStyle(fontSize: 30),
                              ),
                              salesState.loading == true
                                  ? CircularProgressIndicator(
                                      color: AppColors.tuitionGreen,
                                    )
                                  : RoundedButton(
                                      color: AppColors.tuitionGreen,
                                      iconData: Icons.credit_score_outlined,
                                      text: AppLocalizations.of(
                                        context,
                                      )!.buy_now,
                                      onTap: () {
                                        context.read<SalesBloc>().add(
                                          SellProducts(
                                            userBuyer: salesState
                                                .selectedUser
                                                ?.id
                                                .toString(),
                                            saleDate: salesState.saleDate,
                                            cart: salesState.cart,
                                            comments: salesState.comments,
                                            isPresale: salesState.isPresale,
                                            isAutosuficientStudent:
                                                salesState
                                                    .selectedUser
                                                    ?.selfSufficient ??
                                                false,
                                            payWithBalance:
                                                salesState.payWithBalance ??
                                                false,
                                            cardId:
                                                (!(salesState.payWithBalance ??
                                                        false) &&
                                                    isPanama &&
                                                    croemState
                                                        is CroemCardsLoaded)
                                                ? (croemState).selectedCard!.id
                                                      .toString()
                                                : (!(salesState
                                                              .payWithBalance ??
                                                          false) &&
                                                      !isPanama &&
                                                      openpayState
                                                          is OpenpayCardsLoaded)
                                                ? (openpayState)
                                                      .selectedCard!
                                                      .id
                                                      .toString()
                                                : null,
                                            deviceSessionId:
                                                (!(salesState.payWithBalance ??
                                                        false) &&
                                                    openpayState
                                                        is OpenpayCardsLoaded)
                                                ? (openpayState)
                                                          .openpay
                                                          ?.deviceSessionId ??
                                                      ""
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
