import 'package:smart_lunch/core/utils/allowed_topup_methods.dart';
import 'package:smart_lunch/core/utils/commission_types.dart';

abstract class TopupEvent {}

class ConfigureTopupEvent extends TopupEvent {
  double minimunRechargeAmount;
  double selectedRechargeAmount;
  double commissionFee;
  bool processingTopup;
  bool chargeCommissionToParent;
  CommissionTypes commissionType;

  ConfigureTopupEvent({
    required this.minimunRechargeAmount,
    required this.selectedRechargeAmount,
    required this.commissionFee,
    required this.processingTopup,
    required this.chargeCommissionToParent,
    required this.commissionType,
  });
}

class ProcessTopupEvent extends TopupEvent {
  bool processingTopup;

  ProcessTopupEvent({required this.processingTopup});
}

class ChangeRechargeAmountEvent extends TopupEvent {
  double selectedRechargeAmount;

  ChangeRechargeAmountEvent({required this.selectedRechargeAmount});
}

class ChangeSetTopupFromInputEvent extends TopupEvent {
  bool setTopupFromInput;

  ChangeSetTopupFromInputEvent({required this.setTopupFromInput});
}

class ChangeInsertedAmountErrorEvent extends TopupEvent {
  bool insertedAmountError;

  ChangeInsertedAmountErrorEvent({required this.insertedAmountError});
}

class ChangeSelectedButtonIndexEvent extends TopupEvent {
  int selectedButtonIndex;

  ChangeSelectedButtonIndexEvent({required this.selectedButtonIndex});
}

class TopupBalanceEvent extends TopupEvent {
  String amount;
  String userBuyer;
  String? cardId;
  String? deviceSessionID;
  String? cvv;
  String? tokenizedCard;
  AllowedPaymentMethods allowedTopupMethods;

  TopupBalanceEvent({
    required this.amount,
    required this.userBuyer,
    required this.allowedTopupMethods,
    this.cvv,
    this.tokenizedCard,
    this.cardId,
    this.deviceSessionID,
  });
}

class ResetTopupEvent extends TopupEvent {}
