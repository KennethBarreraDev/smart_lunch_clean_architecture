// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:smart_lunch/data/models/school_model.dart';

class Cafeteria {
  int? id;
  String? name;
  String? menu;
  String? logo;
  School? school;
  String? phone;
  String? email;
  Cafeteria({
    this.id,
    this.name,
    this.menu,
    this.logo,
    this.school,
    this.phone,
    this.email,
  });

  Cafeteria copyWith({
    int? id,
    String? name,
    String? menu,
    String? logo,
    School? school,
    String? phone,
    String? email,
  }) {
    return Cafeteria(
      id: id ?? this.id,
      name: name ?? this.name,
      menu: menu ?? this.menu,
      logo: logo ?? this.logo,
      school: school ?? this.school,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'menu': menu,
      'logo': logo,
      'school': school?.toMap(),
      'phone': phone,
      'email': email,
    };
  }

  factory Cafeteria.fromMap(Map<String, dynamic> map) {
    return Cafeteria(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      menu: map['menu'] != null ? map['menu'] as String : null,
      logo: map['logo'] != null ? map['logo'] as String : null,
      school: map['school'] != null ? School.fromMap(map['school'] as Map<String,dynamic>) : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cafeteria.fromJson(Map<String, dynamic> source) => Cafeteria.fromMap(source);

  

}
