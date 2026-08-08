import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_state.dart';
import 'package:smart_lunch/blocs/openpay/openpay_bloc.dart';
import 'package:smart_lunch/blocs/openpay/openpay_event.dart';
import 'package:smart_lunch/blocs/openpay/openpay_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/bank_cards/empty_cards_component.dart';
import 'package:smart_lunch/core/base_widgets/bank_cards/panama/add_card_button.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/base_widgets/snackbar/app_snackbar.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/data/models/openpay_card.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';
import 'package:go_router/go_router.dart';

import 'widgets/delete_card_modal.dart';
import 'widgets/payment_card_item.dart';

class PaymentInformationPage extends StatefulWidget {
  const PaymentInformationPage({super.key});

  @override
  State<PaymentInformationPage> createState() =>
      _PaymentInformationPageState();
}

class _PaymentInformationPageState extends State<PaymentInformationPage> {
  bool _isDeletingCard = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestCardsIfNeeded());
  }

  void _requestCardsIfNeeded() {
    if (!mounted) return;

    final bloc = context.read<OpenpayBloc>();
    final state = bloc.state;

    if (state is OpenpayInitial) {
      bloc.add(ConfigureOpenpayEvent());
    } else if (state is OpenpayLoaded) {
      bloc.add(LoadOpenpayCardsEvent(state.openpay));
    } else if (state is OpenpayCardsLoaded && state.cards == null) {
      bloc.add(LoadOpenpayCardsEvent(state.openpay));
    }
  }

  void _confirmDeleteCard(
    BuildContext context,
    OpenpayCardsLoaded state,
    OpenpayCard card,
  ) {
    showDialog(
      context: context,
      builder: (_) => DeleteCardModal(
        cardLastDigits: card.cardNumber,
        onConfirm: () {
          _isDeletingCard = true;
          context.read<OpenpayBloc>().add(
            DeleteOpenpayCardEvent(
              state.openpay,
              card.id ?? "",
              state.cards ?? [],
              state.selectedCard,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppVersionBloc, AppVersionState>(
          listener: (context, state) {
            //TODO: Show version modal
          },
        ),
        BlocListener<OpenpayBloc, OpenpayState>(
          listener: (context, state) {
            if (state is OpenpayLoaded) {
              context.read<OpenpayBloc>().add(
                LoadOpenpayCardsEvent(state.openpay),
              );
            }

            if (state is OpenpayCardDeleted) {
              _isDeletingCard = false;
              AppSnackbar.show(
                AppLocalizations.of(context)!.delete_card_successfully,
              );
            }

            if (state is OpenpayError && _isDeletingCard) {
              _isDeletingCard = false;
              AppSnackbar.show(
                AppLocalizations.of(context)!.removing_card_error,
              );
            }
          },
        ),
      ],
      child: TransparentScaffold(
        selectedOption: "Ajustes",
        body: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(
                  height: 120,
                  image: AppImages.cardImg,
                  showPageTitle: true,
                  pageTitle: AppLocalizations.of(context)!.payment_methods_message,
                  showDrawer: false,
                  showSchoolLogo: false,
                  hideGoBackText: false,
                  titleAlignment: Alignment.bottomLeft,
                  titleTopPadding: 0.4,
                  titleSize: 28.0,
                ),
                Expanded(
                  child: BlocBuilder<OpenpayBloc, OpenpayState>(
                    builder: (context, state) {
                      if (state is OpenpayInitial || state is OpenpayLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final cards = state is OpenpayCardsLoaded
                          ? (state.cards ?? [])
                          : <OpenpayCard>[];

                      return Column(
                        children: [
                          AddCardButton(
                            isPanama: false,
                            cardsAmount: cards.length,
                          ),
                          Expanded(
                            child: _buildContent(context, state, cards),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    OpenpayState state,
    List<OpenpayCard> cards,
  ) {
    if (state is OpenpayError) {
      return Center(
        child: Text(AppLocalizations.of(context)!.try_again_later),
      );
    }

    if (state is! OpenpayCardsLoaded) {
      return const SizedBox.shrink();
    }

    if (cards.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: EmptyCardsComponent(
          onTap: () => context.pushNamed(
            AppRoutes.getCleanRouteName(AppRoutes.registerOpenpayCard),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];

        return PaymentCardItem(
          card: card,
          isPrincipal: card.id == state.selectedCard?.id,
          onDelete: () => _confirmDeleteCard(context, state, card),
        );
      },
    );
  }
}
