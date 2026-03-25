import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/recharge_history_model.dart';
import 'package:smart_lunch/data/models/user_model.dart';
import 'package:smart_lunch/data/repositories/History/History_repository.dart';

import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository repository;

  HistoryBloc(this.repository) : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_loadHistory);
  }

  Future<void> _loadHistory(
    HistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());

    try {
      List<RechargeHistory> history = await repository.loadRechargesHistory();
      emit(HistoryLoaded(rechargeHistory: history));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
