import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/croem/croem_event.dart';
import 'package:smart_lunch/core/stages/app_stage.dart';
import 'package:smart_lunch/data/models/croem_card.dart';
import 'package:smart_lunch/data/models/openpay_card.dart';
import 'package:smart_lunch/data/providers/openpay_provider.dart';
import 'package:smart_lunch/data/repositories/croem/croem_repository.dart';

import 'package:smart_lunch/data/repositories/openpay/openpay_repository.dart';

import 'croem_state.dart';

class CroemBloc extends Bloc<CroemEvent, CroemState> {
  final CroemRepository repository;

  CroemBloc(this.repository) : super(CroemInitial()) {
    on<LoadCroemCardsEvent>(_loadCroemCards);
    on<RegisterCroemCardEvent>(_registerCroemCard);
  }

  Future<void> _loadCroemCards(
    LoadCroemCardsEvent event,
    Emitter<CroemState> emit,
  ) async {
    emit(CroemLoading());

    try {
      List<CroemCard> cards = await repository.getCroemCards();
      emit(
        CroemCardsLoaded(
          cards: cards,
          selectedCard: cards.isEmpty ? null : cards.first,
        ),
      );
    } catch (e) {
      emit(CroemError(e.toString()));
    }
  }

  Future<void> _registerCroemCard(
    RegisterCroemCardEvent event,
    Emitter<CroemState> emit,
  ) async {
    emit(CroemLoading());

    try {
      CroemCard card = await repository.registerCroemCard(
        event.tokenizedCard ?? "",
        event.userID ?? "",
        event.cardNumber ?? "",
        event.cardHolderName ?? "",
        event.identifierName ?? "",
        (event.cards ?? []).length,
      );
      emit(
        CroemCardsLoaded(
          cards: [...(event.cards ?? []), card],
          selectedCard: card,
        ),
      );
    } catch (e) {
      emit(CroemError(e.toString()));
    }
  }
}
