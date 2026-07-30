import 'dart:convert';

class Alergy {
  final int id;
  final String name;
  final String description;

  Alergy({required this.id, required this.name, required this.description});

  Alergy copyWith({
    int? id,
    String? name,
    String? description,
    int? cafeteria,
  }) => Alergy(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
  );

  factory Alergy.fromJson(Map<String, dynamic> json) => Alergy(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
    };
  }

  String toJsonString() => json.encode(toMap());
}
