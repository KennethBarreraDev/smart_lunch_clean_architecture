// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:intl/intl.dart';

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
    final DateTime? date = DateTime.tryParse(
      map['recharge_date']?.toString() ?? '',
    )?.toLocal();

    return RechargeHistory(
      id: map['id']?.toString(),
      rechargeUser: map['user_recharger']?['username'] as String?,
      rechargeDate: date != null ? DateFormat('dd/MM/yyyy').format(date) : null,
      rechargeTime: date != null ? DateFormat('HH:mm').format(date) : null,
      total: map['amount']?.toString(),
      platform: map['payment_method'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory RechargeHistory.fromJson(Map<String, dynamic> source) => RechargeHistory.fromMap(source);
}
