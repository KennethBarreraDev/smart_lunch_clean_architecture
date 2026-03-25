import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/data/repositories/family/family_repository.dart';

import 'family_event.dart';
import 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  final FamlilyRepository repository;

  FamilyBloc(this.repository) : super(FamilyInitial()) {
    on<LoadFamilyEvent>(_loadFamily);
    on<UpdateFamilyEvent>(_updateFamily);
  }

  void _updateFamily(UpdateFamilyEvent event, Emitter<FamilyState> emit) {
    emit(FamilyLoaded(event.balance));
  }

  Future<void> _loadFamily(FamilyEvent event, Emitter<FamilyState> emit) async {
    emit(FamilyLoading());

    try {
      double balance = await repository.loadFamily();
      emit(FamilyLoaded(balance));
    } catch (e) {
      emit(FamilyError(e.toString()));
    }
  }
}
