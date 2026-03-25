// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? userType;
  final String? birthDate;
  final String? picture;
  final int? school;
  final int? family;
  final String? address;
  final String? phone;
  String? openPayId;
  UserModel({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.userType,
    this.birthDate,
    this.picture,
    this.school,
    this.family,
    this.address,
    this.phone,
    this.openPayId,
  });

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? userType,
    String? birthDate,
    String? picture,
    int? school,
    int? family,
    String? address,
    String? phone,
    String? openPayId,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userType: userType ?? this.userType,
      birthDate: birthDate ?? this.birthDate,
      picture: picture ?? this.picture,
      school: school ?? this.school,
      family: family ?? this.family,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      openPayId: openPayId ?? this.openPayId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'userType': userType,
      'birthDate': birthDate,
      'picture': picture,
      'school': school,
      'family': family,
      'address': address,
      'phone': phone,
      'openPayId': openPayId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as int : null,
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      firstName: map['first_name'] != null ? map['first_name'] as String : null,
      lastName: map['last_name'] != null ? map['last_name'] as String : null,
      userType: map['user_type'] != null ? map['user_type'] as String : null,
      birthDate: map['birthDate'] != null ? map['birthDate'] as String : null,
      picture: map['picture'] != null ? map['picture'] as String : null,
      school: map['school'] != null ? map['school'] as int : null,
      family: map['family'] != null ? map['family'] as int : null,
      address: map['address'] != null ? map['address'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      openPayId: map['openPayId'] != null ? map['openPayId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(Map<String, dynamic> source) => UserModel.fromMap(source);

}
