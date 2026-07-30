import 'package:smart_lunch/data/models/ingredients_model.dart';

abstract class IngredientState {
  const IngredientState();
}

class IngredientInitial extends IngredientState {}

class IngredientLoading extends IngredientState {}

class IngredientLoaded extends IngredientState {
  final List<Ingredient> ingredients;

  const IngredientLoaded(this.ingredients);
}

class IngredientError extends IngredientState {
  final String message;

  const IngredientError(this.message);
}
