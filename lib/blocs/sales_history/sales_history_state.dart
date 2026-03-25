import 'package:smart_lunch/data/models/presale_model.dart';

abstract class SalesHistoryState {}

class SalesHistoryInitial extends SalesHistoryState {}

class SalesHistoryLoading extends SalesHistoryState {}

class SalesHistoryLoaded extends SalesHistoryState {
  List<Presale> sales;
  List<Presale> presales;

  SalesHistoryLoaded(this.sales, this.presales);
}

class SalesHistoryError extends SalesHistoryState {
  final String message;

  SalesHistoryError(this.message);
}