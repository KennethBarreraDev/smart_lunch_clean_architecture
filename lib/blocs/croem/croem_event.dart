import 'package:smart_lunch/data/models/croem_card.dart';
import 'package:smart_lunch/data/providers/openpay_provider.dart';

abstract class CroemEvent {}

class ConfigureCroemEvent extends CroemEvent {
  ConfigureCroemEvent();
}

class LoadCroemCardsEvent extends CroemEvent {}

class RegisterCroemCardEvent extends CroemEvent {
  String? tokenizedCard;
  String? userID;
  String? cardNumber;
  String? cardHolderName;
  String? identifierName;
  List<CroemCard>? cards;


  RegisterCroemCardEvent(
   {
     this.tokenizedCard,
    this.userID,
    this.cardNumber,
    this.cardHolderName,
    this.identifierName,
    this.cards,
   }
  );
}
