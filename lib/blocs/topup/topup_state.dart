import 'package:smart_lunch/core/utils/allowed_topup_methods.dart';
import 'package:smart_lunch/core/utils/commission_types.dart';

class TopupState {
  double minimunRechargeAmount;
  double selectedRechargeAmount;
  double commissionFee;
  bool processingTopup;
  bool chargeCommissionToParent;
  CommissionTypes commissionType;
  int selectedButtonIndex;
  bool setTopupFromInput;
  bool insertedAmountError = false;

  TopupState({
    required this.minimunRechargeAmount,
    required this.selectedRechargeAmount,
    required this.commissionFee,
    required this.processingTopup,
    required this.chargeCommissionToParent,
    required this.commissionType,
    this.selectedButtonIndex = 0,
    this.setTopupFromInput = false,
    this.insertedAmountError = false,
  });

  TopupState copyWith({
    double? minimunRechargeAmount,
    double? selectedRechargeAmount,
    double? commissionFee,
    bool? processingTopup,
    bool? chargeCommissionToParent,
    CommissionTypes? commissionType,
    int? selectedButtonIndex,
    bool? setTopupFromInput,
    bool? insertedAmountError,
  }) {
    return TopupState(
      minimunRechargeAmount:
          minimunRechargeAmount ?? this.minimunRechargeAmount,
      selectedRechargeAmount:
          selectedRechargeAmount ?? this.selectedRechargeAmount,
      commissionFee: commissionFee ?? this.commissionFee,
      processingTopup: processingTopup ?? this.processingTopup,
      chargeCommissionToParent:
          chargeCommissionToParent ?? this.chargeCommissionToParent,
      commissionType: commissionType ?? this.commissionType,
      selectedButtonIndex: selectedButtonIndex ?? this.selectedButtonIndex,
      setTopupFromInput: setTopupFromInput ?? this.setTopupFromInput,
      insertedAmountError: insertedAmountError ?? this.insertedAmountError,
    );
  }
}

class TopupSuccessState extends TopupState {
  final String? topUpId;
  final String transactionFolio;
  final String transactionStatus;
  final AllowedPaymentMethods selectedMethod;

  TopupSuccessState({
    required this.topUpId,
    required this.transactionFolio,
    required this.transactionStatus,
    required this.selectedMethod,
    required double minimunRechargeAmount,
    required double selectedRechargeAmount,
    required double commissionFee,
    required bool processingTopup,
    required bool chargeCommissionToParent,
    required CommissionTypes commissionType,
    required int selectedButtonIndex,
    required bool setTopupFromInput,
    required bool insertedAmountError,
  }) : super(
         minimunRechargeAmount: minimunRechargeAmount,
         selectedRechargeAmount: selectedRechargeAmount,
         commissionFee: commissionFee,
         processingTopup: processingTopup,
         chargeCommissionToParent: chargeCommissionToParent,
         commissionType: commissionType,
         selectedButtonIndex: selectedButtonIndex,
         setTopupFromInput: setTopupFromInput,
         insertedAmountError: insertedAmountError,
       );
}

class TopupErrorState extends TopupState {
  TopupErrorState({
    required double minimunRechargeAmount,
    required double selectedRechargeAmount,
    required double commissionFee,
    required bool processingTopup,
    required bool chargeCommissionToParent,
    required CommissionTypes commissionType,
    required int selectedButtonIndex,
    required bool setTopupFromInput,
    required bool insertedAmountError,
  }) : super(
         minimunRechargeAmount: minimunRechargeAmount,
         selectedRechargeAmount: selectedRechargeAmount,
         commissionFee: commissionFee,
         processingTopup: processingTopup,
         chargeCommissionToParent: chargeCommissionToParent,
         commissionType: commissionType,
         selectedButtonIndex: selectedButtonIndex,
         setTopupFromInput: setTopupFromInput,
         insertedAmountError: insertedAmountError,
       );
}

class InitialTopupState extends TopupState {
  InitialTopupState()
    : super(
        minimunRechargeAmount: 0,
        selectedRechargeAmount: 0,
        commissionFee: 0,
        processingTopup: false,
        chargeCommissionToParent: false,
        commissionType: CommissionTypes.none,
        selectedButtonIndex: 0,
        setTopupFromInput: false,
        insertedAmountError: false,
      );
}
