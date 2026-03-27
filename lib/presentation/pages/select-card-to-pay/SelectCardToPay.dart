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
    final cafeteriaState = context.watch<CafeteriaBloc>().state;
    final openpayState = context.watch<OpenpayBloc>().state;
    final croemState = context.watch<CroemBloc>().state;

    if (cafeteriaState is! CafeteriaSuccess) {
      return const SizedBox.shrink();
    }

    final isPanama = Countries.isPanama(
      cafeteriaState.selected.school?.country ?? "",
    );

    return TransparentScaffold(
      selectedOption: "Inicio",
      showDrawer: false,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildBackground(),
                _buildTitle(context),
                _buildCardContainer(
                  context,
                  isPanama,
                  openpayState,
                  croemState,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Column(
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
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: (20.h * 0.4) / 2.2)),
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
    );
  }

  Widget _buildCardContainer(
    BuildContext context,
    bool isPanama,
    OpenpayState openpayState,
    CroemState croemState,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 110),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                _buildCardsList(context, isPanama, openpayState, croemState),
                _buildLoading(openpayState, croemState),
                _buildSelectButton(context, isPanama, openpayState, croemState),
                _buildAddCardButton(
                  context,
                  isPanama,
                  openpayState,
                  croemState,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            AppLocalizations.of(context)!.cards_message,
            style: const TextStyle(fontSize: 16, fontFamily: "Comfortaa"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Divider(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ],
    );
  }

  Widget _buildCardsList(
    BuildContext context,
    bool isPanama,
    OpenpayState openpayState,
    CroemState croemState,
  ) {
    final cards = isPanama
        ? (croemState is CroemCardsLoaded ? croemState.cards ?? [] : [])
        : (openpayState is OpenpayCardsLoaded ? openpayState.cards ?? [] : []);

    if (cards.isEmpty) return const SizedBox.shrink();

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: cards.map((card) {
        return SaleCardComponent(
          cardId: card.id.toString() ?? "",
          cardNumber: card.cardNumber ?? "",
          holderName: isPanama
              ? card.cardHolderName ?? ""
              : card.holderName ?? "",
          internalId: card.internalId,
          cardBrand: CardsUtils.getCardBrand(card.cardNumber ?? ""),
          onSelectCard: (value) {
            if (isPanama && croemState is CroemCardsLoaded) {
              context.read<CroemBloc>().add(
                TemporallyChangeSelectedCroemCardEvent(
                  croemState.cards,
                  value,
                  croemState.selectedCard,
                ),
              );
            } else if (!isPanama && openpayState is OpenpayCardsLoaded) {
              context.read<OpenpayBloc>().add(
                TemporallyChangeSelectedOpenpayCardEvent(
                  openpayState.cardBrand,
                  openpayState.openpay,
                  openpayState.selectedCard,
                  openpayState.cards ?? [],
                  value,
                ),
              );
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildLoading(OpenpayState openpayState, CroemState croemState) {
    if (openpayState is OpenpayLoading || croemState is CroemLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return const SizedBox.shrink();
  }

  Widget _buildSelectButton(
    BuildContext context,
    bool isPanama,
    OpenpayState openpayState,
    CroemState croemState,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            if (isPanama && croemState is CroemCardsLoaded) {
              context.read<CroemBloc>().add(
                SelectMainCroemCardEvent(
                  croemState.cards,
                  croemState.temporalCardID,
                ),
              );
            } else if (!isPanama && openpayState is OpenpayCardsLoaded) {
              context.read<OpenpayBloc>().add(
                SelectMainOpenpayCardEvent(
                  openpayState.cardBrand,
                  openpayState.openpay,
                  openpayState.cards ?? [],
                  openpayState.temporalCardID,
                ),
              );
            }
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.tuitionGreen.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.credit_score_outlined, color: AppColors.tuitionGreen),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.select_button,
                style: TextStyle(color: AppColors.tuitionGreen),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddCardButton(
    BuildContext context,
    bool isPanama,
    OpenpayState openpayState,
    CroemState croemState,
  ) {
    final length = isPanama
        ? (croemState is CroemCardsLoaded ? (croemState.cards ?? []).length : 0)
        : (openpayState is OpenpayCardsLoaded
              ? (openpayState.cards ?? []).length
              : 0);

    if (length >= 3) return const SizedBox.shrink();

    final route = isPanama
        ? AppRoutes.registerCroemCard
        : AppRoutes.registerOpenpayCard;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            context.pushNamed(AppRoutes.getCleanRouteName(route));
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.lightBlue.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_card_outlined, color: AppColors.lightBlue),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.add_card,
                style: TextStyle(color: AppColors.lightBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
