import 'package:smart_lunch/data/models/croem_card.dart';
abstract class CroemState {}

class CroemInitial extends CroemState {}

class CroemLoading extends CroemState {}



class CroemCardsLoaded extends CroemState {
  List<CroemCard>? cards;
  CroemCard? selectedCard;

  CroemCardsLoaded({this.cards, this.selectedCard});
}

class CroemError extends CroemState {
  final String message;

  CroemError(this.message);
}
