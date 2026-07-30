import 'dart:convert';

class Ingredient {
  final int id;
  final String name;
  final String description;
  final int cafeteria;

  Ingredient({
    required this.id,
    required this.name,
    required this.description,
    required this.cafeteria,
  });

  Ingredient copyWith({
    int? id,
    String? name,
    String? description,
    int? cafeteria,
  }) => Ingredient(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    cafeteria: cafeteria ?? this.cafeteria,
  );

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    cafeteria: json["cafeteria"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "cafeteria": cafeteria,
  };

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'cafeteria': cafeteria,
    };
  }

  String toJsonString() => json.encode(toMap());
}
