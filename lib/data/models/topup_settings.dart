// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:smart_lunch/core/utils/commission_types.dart';

class TopupSettings {
  final double minimunRechargeAmount;
  final double selectedRechargeAmount;
  final double commissionFee;
  final bool chargeCommissionToParent;
  final CommissionTypes commissionType;
  TopupSettings({
    required this.minimunRechargeAmount,
    required this.selectedRechargeAmount,
    required this.commissionFee,
    required this.chargeCommissionToParent,
    required this.commissionType,
  }); 
}
