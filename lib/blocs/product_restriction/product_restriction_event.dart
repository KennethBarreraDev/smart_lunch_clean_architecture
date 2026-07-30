abstract class ProductRestrictionEvent {
  const ProductRestrictionEvent();
}

class LoadProductRestrictions extends ProductRestrictionEvent {
  final int studentId;

  const LoadProductRestrictions({required this.studentId});
}

class RefreshProductRestrictions extends ProductRestrictionEvent {
  final int studentId;

  const RefreshProductRestrictions({required this.studentId});
}

class ToggleProductRestriction extends ProductRestrictionEvent {
  final int studentId;
  final int productId;
  final bool isActive;

  const ToggleProductRestriction({
    required this.studentId,
    required this.productId,
    required this.isActive,
  });
}

/// [value] es el string "prohibited" o una cantidad como string
/// Una selección de "prohibited" actualiza restriction_type; cualquier otro
/// valor actualiza quantity (mínimo 1).
class UpdateProductRestrictionLimit extends ProductRestrictionEvent {
  final int studentId;
  final int productId;
  final String value;

  const UpdateProductRestrictionLimit({
    required this.studentId,
    required this.productId,
    required this.value,
  });
}
