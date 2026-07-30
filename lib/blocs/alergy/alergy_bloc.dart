import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/alergy/alergy_event.dart';
import 'package:smart_lunch/blocs/alergy/alergy_state.dart';
import 'package:smart_lunch/data/models/alergy_model.dart';
import 'package:smart_lunch/data/repositories/alergy/alergy_repository.dart';

class AlergyBloc extends Bloc<AlergyEvent, AlergyState> {
  final AlergyRepository repository;

  AlergyBloc(this.repository) : super(AlergyInitial()) {
    on<LoadAlergies>(_onLoadAlergies);
    on<RefreshAlergies>(_onRefreshAlergies);
  }

  Future<void> _onLoadAlergies(
    LoadAlergies event,
    Emitter<AlergyState> emit,
  ) async {
    emit(AlergyLoading());

    try {
      final List<Alergy> alergy = await repository.loadAlergies();
      emit(AlergyLoaded(alergy));
    } catch (e) {
      emit(AlergyError('Error al cargar Alergies: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshAlergies(
    RefreshAlergies event,
    Emitter<AlergyState> emit,
  ) async {
    add(LoadAlergies());
  }
}
