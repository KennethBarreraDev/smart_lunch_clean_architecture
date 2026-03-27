import 'package:smart_lunch/data/models/openpay_card.dart';
import 'package:smart_lunch/data/providers/openpay_provider.dart';

abstract class OpenpayEvent {}

class ConfigureOpenpayEvent extends OpenpayEvent {
  ConfigureOpenpayEvent();
}

class LoadOpenpayCardsEvent extends OpenpayEvent {
  Openpay? openpay;

  LoadOpenpayCardsEvent(this.openpay);
}

class ChangeOpenpayCardBrandEvent extends OpenpayEvent {
  Openpay? openpay;
  String cardBrand;
  OpenpayCard? selectedCard;
  List<OpenpayCard> cards;
  String temporalCardID;

  ChangeOpenpayCardBrandEvent(
    this.cardBrand,
    this.openpay,
    this.selectedCard,
    this.cards,
    this.temporalCardID,
  );
}

class SelectMainOpenpayCardEvent extends OpenpayEvent {
  Openpay? openpay;
  String cardBrand;
  List<OpenpayCard> cards;
  String temporalCardID;

  SelectMainOpenpayCardEvent(
    this.cardBrand,
    this.openpay,
    this.cards,
    this.temporalCardID,
  );
}

class TemporallyChangeSelectedOpenpayCardEvent extends OpenpayEvent {
  Openpay? openpay;
  String cardBrand;
  OpenpayCard? selectedCard;
  List<OpenpayCard> cards;
  String temporalCardID;

  TemporallyChangeSelectedOpenpayCardEvent(
    this.cardBrand,
    this.openpay,
    this.selectedCard,
    this.cards,
    this.temporalCardID,
  );
}

class RegisterOpenpayCardEvent extends OpenpayEvent {
  Openpay? openpay;
  String holderName;
  String cardNumber;
  String cvv2;
  String expirationMonth;
  String expirationYear;
  int internalId;
  String deviceSessionId;
  List<OpenpayCard> cards;

  RegisterOpenpayCardEvent(
    this.openpay,
    this.holderName,
    this.cardNumber,
    this.cvv2,
    this.expirationMonth,
    this.expirationYear,
    this.internalId,
    this.deviceSessionId,
    this.cards,
  );
}
