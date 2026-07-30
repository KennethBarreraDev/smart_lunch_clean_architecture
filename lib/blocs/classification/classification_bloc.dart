import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/classification/classification_event.dart';
import 'package:smart_lunch/blocs/classification/classification_state.dart';
import 'package:smart_lunch/data/models/classification_model.dart';
import 'package:smart_lunch/data/repositories/classification/classification_respository.dart';

class ClassificationBloc extends Bloc<ClassificationEvent, ClassificationState> {
  final ClassificationRepository repository;

  ClassificationBloc(this.repository) : super(ClassificationInitial()) {
    on<LoadClassifications>(_onLoadClassifications);
    on<RefreshClassifications>(_onRefreshClassifications);
  }

  Future<void> _onLoadClassifications(
    LoadClassifications event,
    Emitter<ClassificationState> emit,
  ) async {
    emit(ClassificationLoading());

    try {
      final List<Classification> classifications =
          await repository.loadClassifications();
      emit(ClassificationLoaded(classifications));
    } catch (e) {
      emit(ClassificationError('Error al cargar clasificaciones: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshClassifications(
    RefreshClassifications event,
    Emitter<ClassificationState> emit,
  ) async {
    add(LoadClassifications());
  }
}
