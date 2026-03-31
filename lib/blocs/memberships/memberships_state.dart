import 'package:smart_lunch/core/utils/allowed_topup_methods.dart';

class MembershipsState {
  final Map<int, int>? membershipCart;
  final double? membershipTotalPrice;
  final bool? loading;
  final AllowedPaymentMethods selectedMethod;
  final String? cardID;
  final String? cvv;

  MembershipsState({
    this.membershipCart,
    this.membershipTotalPrice,
    this.loading,
    this.selectedMethod = AllowedPaymentMethods.croem,
    this.cardID,
    this.cvv,
  });

  MembershipsState copyWith({
    Map<int, int>? membershipCart,
    double? membershipTotalPrice,
    bool? loading,
    AllowedPaymentMethods? selectedMethod,
    String? cardID,
    String? cvv,
  }) {
    return MembershipsState(
      membershipCart: membershipCart ?? this.membershipCart,
      membershipTotalPrice: membershipTotalPrice ?? this.membershipTotalPrice,
      loading: loading ?? this.loading,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      cardID: cardID ?? this.cardID,
      cvv: cvv ?? this.cvv,
    );
  }
}

class MembershipSuccessState extends MembershipsState {
  final String? transactionStatus;

  MembershipSuccessState({
    Map<int, int>? membershipCart,
    double? membershipTotalPrice,
    bool? loading,
    AllowedPaymentMethods? selectedMethod,
    String? cardID,
    String? cvv,
    this.transactionStatus,
  }) : super(
         membershipCart: membershipCart,
         membershipTotalPrice: membershipTotalPrice,
         loading: loading,
         selectedMethod: selectedMethod ?? AllowedPaymentMethods.croem,
         cardID: cardID,
         cvv: cvv,
       );
}

class MembershipErrorState extends MembershipsState {
  MembershipErrorState({
    Map<int, int>? membershipCart,
    double? membershipTotalPrice,
    bool? loading,
    AllowedPaymentMethods? selectedMethod,
    String? cardID,
    String? cvv,
  }) : super(
         membershipCart: membershipCart,
         membershipTotalPrice: membershipTotalPrice,
         loading: loading,
         selectedMethod: selectedMethod ?? AllowedPaymentMethods.croem,
         cardID: cardID,
         cvv: cvv,
       );
}

class InitialMembershipState extends MembershipsState {
  InitialMembershipState()
    : super(
        membershipCart: {},
        membershipTotalPrice: 0,
        loading: false,
        selectedMethod: AllowedPaymentMethods.croem,
        cardID: null,
        cvv: null,
      );
}
