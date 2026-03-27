import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/croem/croem_event.dart';
import 'package:smart_lunch/data/models/croem_card.dart';
import 'package:smart_lunch/data/repositories/croem/croem_repository.dart';

import 'croem_state.dart';

class CroemBloc extends Bloc<CroemEvent, CroemState> {
  final CroemRepository repository;

  CroemBloc(this.repository) : super(CroemInitial()) {
    on<LoadCroemCardsEvent>(_loadCroemCards);
    on<RegisterCroemCardEvent>(_registerCroemCard);
    on<TemporallyChangeSelectedCroemCardEvent>(
      _temporallyChangeSelectedCroemCard,
    );
    on<SelectMainCroemCardEvent>(_selectMainCroemCard);
  }
  void _selectMainCroemCard(
    SelectMainCroemCardEvent event,
    Emitter<CroemState> emit,
  ) {
    emit(CroemLoading());

    try {
      final CroemCard? selectedCard =
          (event.cards ?? []).any(
            (card) => card.id.toString() == event.temporalCardID,
          )
          ? event.cards?.firstWhere(
              (card) => card.id.toString() == event.temporalCardID,
            )
          : event.cards?.first;

      emit(
        CroemCardsLoaded(
          cards: event.cards,
          selectedCard: selectedCard,
          temporalCardID: event.temporalCardID,
        ),
      );
    } catch (e) {
      emit(CroemError(e.toString()));
    }
  }

  _temporallyChangeSelectedCroemCard(
    TemporallyChangeSelectedCroemCardEvent event,
    Emitter<CroemState> emit,
  ) {
    emit(CroemLoading());

    try {
      emit(
        CroemCardsLoaded(
          cards: event.cards,
          selectedCard: event.selectedCard,
          temporalCardID: event.temporalCardID,
        ),
      );
    } catch (e) {
      emit(CroemError(e.toString()));
    }
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
