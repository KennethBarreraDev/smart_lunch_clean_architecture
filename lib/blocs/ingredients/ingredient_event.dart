abstract class IngredientEvent{
  const IngredientEvent();
}

class LoadIngredients extends IngredientEvent {
  final int? cafeteriaId;

  const LoadIngredients({this.cafeteriaId});
}

class RefreshIngredients extends IngredientEvent {
  final int? cafeteriaId;

  const RefreshIngredients({this.cafeteriaId});
}