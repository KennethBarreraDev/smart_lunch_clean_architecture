import 'package:smart_lunch/core/utils/allowed_topup_methods.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/product_model.dart';

abstract class MembershipsEvent {}

class AddUserToMembershipToPayment extends MembershipsEvent {
  final CafeteriaUser user;

  AddUserToMembershipToPayment(this.user);
}

class RemoveUserFromMembershipPayment extends MembershipsEvent {
  final CafeteriaUser user;
  RemoveUserFromMembershipPayment(this.user);
}

class IsLoadingMemberships extends MembershipsEvent {
  final bool isLoading;

  IsLoadingMemberships(this.isLoading);
}

class PayMemberships extends MembershipsEvent {
  final Map<int, int>? membershipCart;
  final double? membershipTotalPrice;
  final bool? loading;
  final AllowedPaymentMethods selectedMethod;
  final String? cardID;
  final String? cvv;

  PayMemberships({
    this.membershipCart,
    this.membershipTotalPrice,
    this.loading,
    required this.selectedMethod,
    this.cardID,
    this.cvv,
  });
}

class ResetMemberships extends MembershipsEvent {
  ResetMemberships();
}

class FillInitialMemberships extends MembershipsEvent {
  final List<CafeteriaUser> users;

  FillInitialMemberships(this.users);
}
