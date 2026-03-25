import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/data/models/presale_model.dart';
import 'package:smart_lunch/data/repositories/sales/sales_repository.dart';

import 'sales_history_event.dart';
import 'sales_history_state.dart';

class SalesHistoryBloc extends Bloc<SalesHistoryEvent, SalesHistoryState> {
  final SalesRepository repository;

  SalesHistoryBloc(this.repository) : super(SalesHistoryInitial()) {
    on<LoadSalesHistoryEvent>(_loadSales);
  }

  Future<void> _loadSales(LoadSalesHistoryEvent event, Emitter<SalesHistoryState> emit) async {
    emit(SalesHistoryLoading());

    try {
      List<Presale> sales = await repository.loadSales(event.user);
      List<Presale> presales = await repository.loadPresales(event.user);
      emit(SalesHistoryLoaded(
        sales,
        presales,
      ));
    } catch (e) {
      emit(SalesHistoryError(e.toString()));
    }
  }
}
