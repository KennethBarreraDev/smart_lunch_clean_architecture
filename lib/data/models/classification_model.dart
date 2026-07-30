import 'dart:convert';

Classification classificationFromJson(String str) =>
    Classification.fromJson(json.decode(str));

String classificationToJson(Classification data) => json.encode(data.toJson());

class Classification {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;

  Classification({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  Classification copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
  }) => Classification(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    createdAt: createdAt ?? this.createdAt,
  );

  factory Classification.fromJson(Map<String, dynamic> json) => Classification(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "created_at": createdAt.toIso8601String(),
  };
}
