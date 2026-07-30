import 'dart:convert';

ProductRestriction productRestrictionFromJson(String str) =>
    ProductRestriction.fromJson(json.decode(str));

String productRestrictionToJson(ProductRestriction data) =>
    json.encode(data.toJson());

class ProductRestriction {
  final int id;
  final int quantity;
  final int student;
  final int product;
  final bool softDeleted;
  final String frequency;
  final String restrictionType;

  ProductRestriction({
    required this.id,
    required this.quantity,
    required this.student,
    required this.product,
    required this.softDeleted,
    required this.frequency,
    required this.restrictionType,
  });

  ProductRestriction copyWith({
    int? id,
    int? quantity,
    int? student,
    int? product,
    bool? softDeleted,
    String? frequency,
    String? restrictionType,
  }) => ProductRestriction(
    id: id ?? this.id,
    quantity: quantity ?? this.quantity,
    student: student ?? this.student,
    product: product ?? this.product,
    softDeleted: softDeleted ?? this.softDeleted,
    frequency: frequency ?? this.frequency,
    restrictionType: restrictionType ?? this.restrictionType,
  );

  factory ProductRestriction.fromJson(Map<String, dynamic> json) =>
      ProductRestriction(
        id: json["id"],
        quantity: json["quantity"],
        student: json["student"],
        product: json["product"],
        softDeleted: json["soft_deleted"],
        frequency: json["frequency"],
        restrictionType: json["restriction_type"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quantity": quantity,
    "student": student,
    "product": product,
    "soft_deleted": softDeleted,
    "frequency": frequency,
    "restriction_type": restrictionType,
  };
}
