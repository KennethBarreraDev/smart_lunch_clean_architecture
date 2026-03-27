import 'package:smart_lunch/data/models/openpay_card.dart';
import 'package:smart_lunch/data/providers/openpay_provider.dart';

abstract class OpenpayState {}

class OpenpayInitial extends OpenpayState {}

class OpenpayLoading extends OpenpayState {}

class OpenpayLoaded extends OpenpayState {
  Openpay openpay;

  OpenpayLoaded({required this.openpay});
}



class OpenpayCardsLoaded extends OpenpayState {
  Openpay? openpay;
  List<OpenpayCard>? cards;
  OpenpayCard? selectedCard;
  String cardBrand;

  OpenpayCardsLoaded({required this.openpay, this.cards, this.selectedCard, this.cardBrand = ""});
}

class OpenpayError extends OpenpayState {
  final String message;

  OpenpayError(this.message);
}
