import 'package:smart_lunch/data/models/product_restrictiction_model.dart';

abstract class ProductRestrictionState {
  const ProductRestrictionState();
}

class ProductRestrictionInitial extends ProductRestrictionState {}

class ProductRestrictionLoading extends ProductRestrictionState {}

class ProductRestrictionLoaded extends ProductRestrictionState {
  final List<ProductRestriction> restrictions;

  const ProductRestrictionLoaded(this.restrictions);
}

class ProductRestrictionError extends ProductRestrictionState {
  final String message;

  const ProductRestrictionError(this.message);
}

/// Emitted when a toggle create/update fails; keeps the last known list so
/// the tabs don't lose their content while the error is shown.
class ProductRestrictionActionError extends ProductRestrictionState {
  final String message;
  final List<ProductRestriction> restrictions;

  const ProductRestrictionActionError(this.message, this.restrictions);
}
