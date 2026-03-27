import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/croem/croem_bloc.dart';
import 'package:smart_lunch/blocs/croem/croem_event.dart';
import 'package:smart_lunch/blocs/croem/croem_state.dart';
import 'package:smart_lunch/blocs/openpay/openpay_bloc.dart';
import 'package:smart_lunch/blocs/openpay/openpay_event.dart';
import 'package:smart_lunch/blocs/openpay/openpay_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/constants/countries.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cards_utils.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/select-card-to-pay/sale_card_component.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class SelectCardToPayPage extends StatelessWidget {
  const SelectCardToPayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TransparentScaffold(
      selectedOption: "Inicio",
      showDrawer: false,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomAppBar(
                      height: 20.h,
                      showPageTitle: true,
                      showDrawer: false,
                      image: AppImages.appBarLongImg,
                      titleTopPadding: 0.3,
                      secondaryColor: true,
                    ),
                    Container(color: AppColors.white, height: 120),
                  ],
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: (20.h * 0.4) / 2.2,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.choose_card,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 110,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                                left: 8,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.cards_message,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Comfortaa",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Divider(
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                            ),
                            BlocBuilder<CafeteriaBloc, CafeteriaState>(
                              builder: (context, cafeteriaState) {
                                if (cafeteriaState is! CafeteriaSuccess) {
                                  return const SizedBox.shrink();
                                }

                                bool isPanama = Countries.isPanama(
                                  cafeteriaState.selected.school?.country ?? "",
                                );

                                return BlocBuilder<OpenpayBloc, OpenpayState>(
                                  builder: (context, openpayState) {
                                    return BlocBuilder<CroemBloc, CroemState>(
                                      builder: (context, croemState) {
                                        return Container(
                                          child:
                                              (isPanama &&
                                                  croemState
                                                      is CroemCardsLoaded)
                                              ? ListView(
                                                  shrinkWrap: false,
                                                  padding: EdgeInsets.zero,
                                                  children: (croemState.cards ?? [])
                                                      .map(
                                                        (
                                                          card,
                                                        ) => SaleCardComponent(
                                                          cardId: card!.id
                                                              .toString(),
                                                          cardNumber:
                                                              card.cardNumber ??
                                                              "",
                                                          holderName:
                                                              card.cardHolderName ??
                                                              "",
                                                          internalId:
                                                              card.internalId,
                                                          cardBrand:
                                                              CardsUtils.getCardBrand(
                                                                card.cardNumber ??
                                                                    "",
                                                              ),
                                                          onSelectCard: (value) {
                                                            if (isPanama &&
                                                                croemState
                                                                    is CroemCardsLoaded) {
                                                              context
                                                                  .read<
                                                                    CroemBloc
                                                                  >()
                                                                  .add(
                                                                    TemporallyChangeSelectedCroemCardEvent(
                                                                      croemState
                                                                          .cards,

                                                                      value,
                                                                      croemState
                                                                          .selectedCard,
                                                                    ),
                                                                  );
                                                            }
                                                          },
                                                        ),
                                                      )
                                                      .toList(),
                                                )
                                              : (!isPanama &&
                                                    openpayState
                                                        is OpenpayCardsLoaded)
                                              ? ListView(
                                                  shrinkWrap: false,
                                                  padding: EdgeInsets.zero,
                                                  children: (openpayState.cards ?? [])
                                                      .map(
                                                        (
                                                          card,
                                                        ) => SaleCardComponent(
                                                          cardId: card!.id
                                                              .toString(),
                                                          cardNumber:
                                                              card.cardNumber,
                                                          holderName:
                                                              card.holderName,
                                                          internalId:
                                                              card.internalId,
                                                          cardBrand:
                                                              CardsUtils.getCardBrand(
                                                                card.cardNumber,
                                                              ),
                                                          onSelectCard: (value) {
                                                            if (!isPanama &&
                                                                openpayState
                                                                    is OpenpayCardsLoaded) {
                                                              context.read<OpenpayBloc>().add(
                                                                TemporallyChangeSelectedOpenpayCardEvent(
                                                                  openpayState
                                                                      .cardBrand,
                                                                  openpayState
                                                                      .openpay,
                                                                  openpayState
                                                                      .selectedCard,
                                                                  openpayState
                                                                          .cards ??
                                                                      [],
                                                                  value,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      )
                                                      .toList(),
                                                )
                                              : SizedBox.shrink(),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),

                            BlocBuilder<OpenpayBloc, OpenpayState>(
                              builder: (context, openpayState) {
                                return BlocBuilder<CroemBloc, CroemState>(
                                  builder: (context, croemState) {
                                    if (openpayState is OpenpayLoading ||
                                        croemState is CroemLoading) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color: AppColors.tuitionGreen,
                                          ),
                                        ],
                                      );
                                    }

                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                              top: 5,
                                              left: 20,
                                              right: 20,
                                            ),
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            child: OutlinedButton(
                                              onPressed: () {},
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: AppColors
                                                    .tuitionGreen
                                                    .withValues(alpha: 0.2),
                                                side: BorderSide(
                                                  color: AppColors.tuitionGreen
                                                      .withValues(alpha: 0.2),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.credit_score_outlined,
                                                    color:
                                                        AppColors.tuitionGreen,
                                                    size: 24,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.select_button,
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .tuitionGreen,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),

                            BlocBuilder<CafeteriaBloc, CafeteriaState>(
                              builder: (context, cafeteriaState) {
                                if (cafeteriaState is! CafeteriaSuccess) {
                                  return const SizedBox.shrink();
                                }

                                return BlocBuilder<OpenpayBloc, OpenpayState>(
                                  builder: (context, openpayBloc) {
                                    return BlocBuilder<CroemBloc, CroemState>(
                                      builder: (context, croemBloc) {
                                        bool isPanama = Countries.isPanama(
                                          cafeteriaState
                                                  .selected
                                                  .school
                                                  ?.country ??
                                              "",
                                        );

                                        if (isPanama &&
                                            croemBloc is CroemCardsLoaded &&
                                            (croemBloc.cards ?? []).length >=
                                                3) {
                                          return const SizedBox.shrink();
                                        }

                                        if (!isPanama &&
                                            openpayBloc is OpenpayCardsLoaded &&
                                            (openpayBloc.cards ?? []).length >=
                                                3) {
                                          return const SizedBox.shrink();
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                            left: 8,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                              left: 20,
                                              right: 20,
                                            ),
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                final route = isPanama
                                                    ? AppRoutes
                                                          .registerCroemCard
                                                    : AppRoutes
                                                          .registerOpenpayCard;

                                                context.pushNamed(
                                                  AppRoutes.getCleanRouteName(
                                                    route,
                                                  ),
                                                );
                                              },
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: AppColors
                                                    .lightBlue
                                                    .withValues(alpha: 0.2),
                                                side: BorderSide(
                                                  color: AppColors.lightBlue
                                                      .withValues(alpha: 0.2),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add_card_outlined,
                                                    color: AppColors.lightBlue,
                                                    size: 24,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.add_card,
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.lightBlue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
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
