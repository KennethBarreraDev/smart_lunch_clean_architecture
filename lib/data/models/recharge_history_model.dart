// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RechargeHistory {
  
  String? id;
  String? rechargeUser;
  String? rechargeDate;
  String? rechargeTime;
  String? total;
  String? platform;
  RechargeHistory({
    this.id,
    this.rechargeUser,
    this.rechargeDate,
    this.rechargeTime,
    this.total,
    this.platform,
  });

  RechargeHistory copyWith({
    String? id,
    String? rechargeUser,
    String? rechargeDate,
    String? rechargeTime,
    String? total,
    String? platform,
  }) {
    return RechargeHistory(
      id: id ?? this.id,
      rechargeUser: rechargeUser ?? this.rechargeUser,
      rechargeDate: rechargeDate ?? this.rechargeDate,
      rechargeTime: rechargeTime ?? this.rechargeTime,
      total: total ?? this.total,
      platform: platform ?? this.platform,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'rechargeUser': rechargeUser,
      'rechargeDate': rechargeDate,
      'rechargeTime': rechargeTime,
      'total': total,
      'platform': platform,
    };
  }

  factory RechargeHistory.fromMap(Map<String, dynamic> map) {
    return RechargeHistory(
      id: map['id'] != null ? map['id'] as String : null,
      rechargeUser: map['rechargeUser'] != null ? map['rechargeUser'] as String : null,
      rechargeDate: map['rechargeDate'] != null ? map['rechargeDate'] as String : null,
      rechargeTime: map['rechargeTime'] != null ? map['rechargeTime'] as String : null,
      total: map['total'] != null ? map['total'] as String : null,
      platform: map['platform'] != null ? map['platform'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RechargeHistory.fromJson(Map<String, dynamic> source) => RechargeHistory.fromMap(source);
}
