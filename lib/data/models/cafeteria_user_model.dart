// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:smart_lunch/data/models/user_model.dart';

class CafeteriaUser {
  final int? id;
  final UserModel? user;
  final double? dailyLimit;
  final double? credit;
  final double? scholarship;
  final String? customAllergy;
  final String? membershipExpiration;
  final double? debt;
  final bool? selfSufficient;
  final bool? membership;
  final int? school;
  CafeteriaUser({
    this.id,
    this.user,
    this.dailyLimit,
    this.credit,
    this.scholarship,
    this.customAllergy,
    this.debt,
    this.selfSufficient,
    this.membership,
    this.school,
    this.membershipExpiration,
  });

  CafeteriaUser copyWith({
    int? id,
    UserModel? user,
    double? dailyLimit,
    double? credit,
    double? scholarship,
    String? customAllergy,
    double? debt,
    bool? selfSufficient,
    bool? membership,
    int? school,
    String? membershipExpiration,
  }) {
    return CafeteriaUser(
      id: id ?? this.id,
      user: user ?? this.user,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      credit: credit ?? this.credit,
      scholarship: scholarship ?? this.scholarship,
      customAllergy: customAllergy ?? this.customAllergy,
      debt: debt ?? this.debt,
      selfSufficient: selfSufficient ?? this.selfSufficient,
      membership: membership ?? this.membership,
      school: school ?? this.school,
      membershipExpiration: membershipExpiration ?? this.membershipExpiration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user?.toMap(),
      'dailyLimit': dailyLimit,
      'credit': credit,
      'scholarship': scholarship,
      'customAllergy': customAllergy,
      'debt': debt,
      'selfSufficient': selfSufficient,
      'membership': membership,
      'school': school,
      'membership_expiration': membershipExpiration,
    };
  }

  factory CafeteriaUser.fromMap(Map<String, dynamic> map) {
    return CafeteriaUser(
      id: map['id'] as int?,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      dailyLimit: map['daily_limit'] != null
          ? double.tryParse(map['daily_limit'].toString())
          : null,
      credit: map['credit'] != null
          ? double.tryParse(map['credit'].toString())
          : null,
      scholarship: map['scholarship'] != null
          ? double.tryParse(map['scholarship'].toString())
          : null,
      customAllergy: map['custom_allergy'] as String?,
      debt: map['debt'] != null
          ? double.tryParse(map['debt'].toString())
          : null,
      selfSufficient: map['self_sufficient'] as bool?,
      membership: map['membership'] as bool?,
      school: map['school'] as int?,
      membershipExpiration: map["membership_expiration"] != null
          ? map['membership_expiration'] as String?
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CafeteriaUser.fromJson(Map<String, dynamic> source) =>
      CafeteriaUser.fromMap(source);
}
