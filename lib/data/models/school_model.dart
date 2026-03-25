// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class School {
  int? id;
  String? name;
  String? address;
  String? logo;
  String? country;
  String? currency;
  School({
    this.id,
    this.name,
    this.address,
    this.logo,
    this.country,
    this.currency,
  });

  School copyWith({
    int? id,
    String? name,
    String? address,
    String? logo,
    String? country,
    String? currency,
  }) {
    return School(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      logo: logo ?? this.logo,
      country: country ?? this.country,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'logo': logo,
      'country': country,
      'currency': currency,
    };
  }

  factory School.fromMap(Map<String, dynamic> map) {
    return School(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      logo: map['logo'] != null ? map['logo'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      currency: map['currency'] != null ? map['currency'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory School.fromJson(Map<String, dynamic> source) => School.fromMap(source);

 
}
