import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/croem/croem_bloc.dart';
import 'package:smart_lunch/blocs/croem/croem_state.dart';
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
import 'package:smart_lunch/core/constants/countries.dart';
import 'package:smart_lunch/core/utils/allowed_topup_methods.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class PanamaCardsSelector extends StatelessWidget {
  const PanamaCardsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, sessionState) {
        if (sessionState is! SessionAuthenticated) {
          return SizedBox.shrink();
        }
        return BlocBuilder<TopupBloc, TopupState>(
          builder: (context, topupState) {
            return BlocBuilder<CafeteriaBloc, CafeteriaState>(
              builder: (context, cafeteriaState) {
                if (cafeteriaState is! CafeteriaSuccess) {
                  return const SizedBox.shrink();
                }

                return BlocBuilder<CroemBloc, CroemState>(
                  builder: (context, croemState) {
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
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: "Comfortaa",
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 8.0,
                                                        ),
                                                    child: Divider(
                                                      color: AppColors.darkBlue
                                                          .withValues(
                                                            alpha: 0.2,
                                                          ),
                                                    ),
                                                  ),

                                                  ...((croemState as CroemCardsLoaded)
                                                              .cards ??
                                                          [])
                                                      .map(
                                                        (
                                                          card,
                                                        ) => SelectCardComponent(
                                                          selectedCard: card,
                                                          onSelectCard: () {
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
                                                                cvv: "",
                                                                tokenizedCard: card
                                                                    .tokenizedCard,
                                                                cardId: card
                                                                    .cardNumber,
                                                                allowedTopupMethods:
                                                                    AllowedTopupMethods
                                                                        .croem,
                                                              ),
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
                                                        (croemState.cards ?? [])
                                                            .length,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  FeeComponent(
                                                    comissionFee:
                                                        CafeteriaConstants
                                                            .croemFee,
                                                    amount: topupState
                                                        .selectedRechargeAmount,
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
                                                    .withValues(alpha: 0.15),
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
                                                    .withValues(alpha: 0.15),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        YappiButton(
                                          onTap: () {
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
                                                    AllowedTopupMethods.yappi,
                                              ),
                                            );
                                          },
                                          loading: topupState.processingTopup,
                                        ),
                                        const SizedBox(height: 10),
                                        FeeComponent(
                                          comissionFee: 2,
                                          amount:
                                              topupState.selectedRechargeAmount,
                                        ),
                                        const SizedBox(height: 40),
                                        SupportComponent(
                                          cafeteria: cafeteriaState.selected,
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
  }
}
