import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/ingredients/ingredient_event.dart';
import 'package:smart_lunch/blocs/ingredients/ingredient_state.dart';
import 'package:smart_lunch/core/constants/cache_keys.dart';
import 'package:smart_lunch/data/models/ingredients_model.dart';
import 'package:smart_lunch/data/providers/secure_storage_provider.dart';
import 'package:smart_lunch/data/repositories/ingredient/ingredient_repository.dart';

class IngredientBloc extends Bloc<IngredientEvent, IngredientState> {
  final IngredientRepository repository;
  final StorageProvider storage;

  IngredientBloc(this.repository, this.storage) : super(IngredientInitial()) {
    on<LoadIngredients>(_onLoadIngredients);
    on<RefreshIngredients>(_onRefreshIngredients);
  }

  Future<void> _onLoadIngredients(
    LoadIngredients event,
    Emitter<IngredientState> emit,
  ) async {
    emit(IngredientLoading());

    try {
      final List<Ingredient> ingredients = await repository.loadIngredients(
        cafeteriaId: await _getCafeteriaID(),
      );
      emit(IngredientLoaded(ingredients));
    } catch (e) {
      emit(IngredientError('Error al cargar ingredientes: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshIngredients(
    RefreshIngredients event,
    Emitter<IngredientState> emit,
  ) async {
    add(LoadIngredients(cafeteriaId: await _getCafeteriaID()));
  }

  Future<int> _getCafeteriaID() async {
    String? cafeteriaId = await storage.readValue(CacheKeys.cafeteriaId);

    if (cafeteriaId.isEmpty || cafeteriaId == "0") {
      return 0;
    }

    return int.tryParse(cafeteriaId) ?? 0;
  }
}
