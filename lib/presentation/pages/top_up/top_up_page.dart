import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart'
    show CafeteriaBloc;
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/openpay/openpay_bloc.dart' show OpenpayBloc;
import 'package:smart_lunch/blocs/openpay/openpay_state.dart';
import 'package:smart_lunch/blocs/session/session_bloc.dart';
import 'package:smart_lunch/blocs/session/session_state.dart';
import 'package:smart_lunch/blocs/topup/topup_bloc.dart';
import 'package:smart_lunch/blocs/topup/topup_event.dart';
import 'package:smart_lunch/blocs/topup/topup_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/go_back_button.dart';
import 'package:smart_lunch/core/base_widgets/openpay/openpay_row.dart';
import 'package:smart_lunch/core/base_widgets/snackbar/generic_snackbar.dart';
import 'package:smart_lunch/core/constants/countries.dart';
import 'package:smart_lunch/core/utils/allowed_topup_methods.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/core/base_widgets/bank_cards/empty_cards_component.dart';
import 'package:smart_lunch/core/base_widgets/bank_cards/select_card_component.dart';
import 'package:smart_lunch/presentation/pages/top_up/widgets/top_up_amount_selector.dart';
import 'package:smart_lunch/presentation/pages/top_up/widgets/top_up_total_card.dart';
import 'package:smart_lunch/presentation/pages/top_up/widgets/topup_balance.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class TopupPage extends StatefulWidget {
  const TopupPage({super.key});

  @override
  State<TopupPage> createState() => _TopupPageState();
}

class _TopupPageState extends State<TopupPage> {
  final TextEditingController rechargeTotalInput = TextEditingController();

  @override
  void dispose() {
    rechargeTotalInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cafeteriaState = context.watch<CafeteriaBloc>().state;
    final topupState = context.watch<TopupBloc>().state;
    final openpayState = context.watch<OpenpayBloc>().state;
    final sessionState = context.watch<SessionBloc>().state;

    if (cafeteriaState is! CafeteriaSuccess) {
      return const SizedBox.shrink();
    }

    final isPanama = Countries.isPanama(
      cafeteriaState.selected.school?.country ?? "",
    );

    final hasCards =
        openpayState is OpenpayCardsLoaded &&
        (openpayState.cards ?? []).isNotEmpty;

    final canUseOpenpay =
        !isPanama && cafeteriaState.cafeteriaSettings.openpayRecharge;

    return BlocListener<TopupBloc, TopupState>(
      listener: (context, topupState) {
        if (topupState is TopupSuccessState) {
          context.pushNamed(AppRoutes.getCleanRouteName(AppRoutes.topupStatus));
        } else if (topupState is TopupErrorState) {
          showCustomSnackBar(
            context: context,
            bannerType: BannerTypes.errorBanner.type,
            bannerMessage: AppLocalizations.of(context)!.recharge_error,
          );
        }
      },
      child: Scaffold(
        body: Container(
          constraints: BoxConstraints(minHeight: 100.h),
          width: 100.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [AppColors.coral, AppColors.orange],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 5.h, left: 16, right: 16),
              child: Column(
                children: [
                  GoBackButton(title: AppLocalizations.of(context)!.top_up),

                  SizedBox(height: 3.h),

                  const TopupBalance(),

                  const SizedBox(height: 5),

                  Divider(color: AppColors.white.withValues(alpha: 0.3)),

                  SizedBox(height: 2.h),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.amount_message,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  TopupAmountSelector(
                    topupState: topupState,
                    isPanama: isPanama,
                    rechargeTotalInput: rechargeTotalInput,
                  ),

                  if (canUseOpenpay) ...[
                    hasCards
                        ? SelectCardComponent(
                            selectedCard: (openpayState as OpenpayCardsLoaded)
                                .selectedCard!,
                            onSelectCard: () {},
                          )
                        : EmptyCardsComponent(
                            onTap: () {
                              final route = isPanama
                                  ? AppRoutes.registerCroemCard
                                  : AppRoutes.registerOpenpayCard;

                              context.pushNamed(
                                AppRoutes.getCleanRouteName(route),
                              );
                            },
                          ),
                    const OpenpayLogosRow(),
                  ],

                  TopUpTotalCard(
                    cafeteriaSetting: cafeteriaState.cafeteriaSettings,
                    topupState: topupState,
                    onTopupBalance: () {
                      if (isPanama) {
                        context.pushNamed(
                          AppRoutes.getCleanRouteName(
                            AppRoutes.panamaCardsSelector,
                          ),
                          extra: true
                        );
                      } else {
                        if (cafeteriaState.cafeteriaSettings.openpayRecharge) {
                          context.read<TopupBloc>().add(
                            TopupBalanceEvent(
                              amount: topupState.selectedRechargeAmount
                                  .toString(),
                              cardId:
                                  (openpayState as OpenpayCardsLoaded)
                                      .selectedCard
                                      ?.id ??
                                  "",
                              userBuyer:
                                  (sessionState as SessionAuthenticated)
                                      .sessionData
                                      ?.userId ??
                                  "",
                              deviceSessionID:
                                  (openpayState).openpay!.deviceSessionId,
                              allowedTopupMethods: AllowedPaymentMethods.openpay,
                            ),
                          );
                        } else {
                          context.read<TopupBloc>().add(
                            TopupBalanceEvent(
                              amount: topupState.selectedRechargeAmount
                                  .toString(),

                              userBuyer:
                                  (sessionState as SessionAuthenticated)
                                      .sessionData
                                      ?.userId ??
                                  "",
                              cardId: null,
                              deviceSessionID: null,
                              allowedTopupMethods:
                                  AllowedPaymentMethods.mercadoPago,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
