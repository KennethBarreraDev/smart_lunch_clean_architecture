import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/core/stages/app_stage.dart';
import 'package:smart_lunch/data/models/openpay_card.dart';
import 'package:smart_lunch/data/providers/openpay_provider.dart';

import 'package:smart_lunch/data/repositories/openpay/openpay_repository.dart';

import 'openpay_event.dart';
import 'openpay_state.dart';

class OpenpayBloc extends Bloc<OpenpayEvent, OpenpayState> {
  final OpenpayRepository repository;

  OpenpayBloc(this.repository) : super(OpenpayInitial()) {
    on<ConfigureOpenpayEvent>(_configureOpenpay);
    on<LoadOpenpayCardsEvent>(_loadOpenpayCards);
    on<RegisterOpenpayCardEvent>(_registerOpenpayCard);
    on<ChangeOpenpayCardBrandEvent>(_changeOpenpayCardBrand);
  }

  Future<void> _changeOpenpayCardBrand(
    ChangeOpenpayCardBrandEvent event,
    Emitter<OpenpayState> emit,
  ) async {
    emit(OpenpayLoading());

    try {
      emit(
        OpenpayCardsLoaded(
          openpay: event.openpay,
          cards: event.cards,
          selectedCard: event.selectedCard,
          cardBrand: event.cardBrand,
        ),
      );
    } catch (e) {
      emit(OpenpayError(e.toString()));
    }
  }

  Future<void> _configureOpenpay(
    OpenpayEvent event,
    Emitter<OpenpayState> emit,
  ) async {
    emit(OpenpayLoading());

    try {
      await repository.createOpenPayCustomer();
      Map<String, dynamic>? responseMap = await repository
          .getOpenPayCredentials();

      String merchantId = responseMap?["merchant_id"] ?? "";
      String publicKey = responseMap?["public_key"] ?? "";
      bool isProductionMode = AppStage.productionMode;

      String deviceSessionId = await repository.getDeviceSessionId();

      Openpay openpay = Openpay(
        merchantId,
        publicKey,
        deviceSessionId,
        isProductionMode: isProductionMode,
      );

      await openpay.initializeOpenpay();

      Map<String, dynamic>? tutorResponseMap = await repository
          .getTutorOpenPayAccount();
      //TODO: add main card id to cards bloc
      String mainCardId = responseMap?["main_payment_token"] ?? "-1";
      String openpayId = responseMap?["openpay_id"] ?? "-1";

      repository.api.sessionRepository.setUserOpenpayId(openpayId);

      emit(OpenpayLoaded(openpay: openpay));
    } catch (e) {
      emit(OpenpayError(e.toString()));
    }
  }

  Future<void> _loadOpenpayCards(
    LoadOpenpayCardsEvent event,
    Emitter<OpenpayState> emit,
  ) async {
    emit(OpenpayLoading());

    try {
      List<OpenpayCard> cards = await repository.getCards();
      emit(
        OpenpayCardsLoaded(
          cards: cards,
          openpay: event.openpay,
          selectedCard: cards.isEmpty ? null : cards.first,
        ),
      );
    } catch (e) {
      emit(OpenpayError(e.toString()));
    }
  }

  Future<void> _registerOpenpayCard(
    RegisterOpenpayCardEvent event,
    Emitter<OpenpayState> emit,
  ) async {
    emit(OpenpayLoading());

    try {
      OpenpayCard card = await repository.registerOpenpayCard(
        holderName: event.holderName,
        cardNumber: event.cardNumber,
        cvv2: event.cvv2,
        expirationMonth: event.expirationMonth,
        expirationYear: event.expirationYear,
        internalId: event.internalId,
        deviceSessionId: event.deviceSessionId,
        openpay: event.openpay!,
      );
      emit(
        OpenpayCardsLoaded(
          cards: [...event.cards, card],
          openpay: event.openpay,
          selectedCard: card,
        ),
      );
    } catch (e) {
      emit(OpenpayError(e.toString()));
    }
  }
}
