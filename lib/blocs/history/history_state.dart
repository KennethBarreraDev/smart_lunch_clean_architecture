import 'package:smart_lunch/data/models/recharge_history_model.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<RechargeHistory> rechargeHistory;
  HistoryLoaded({required this.rechargeHistory});
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}