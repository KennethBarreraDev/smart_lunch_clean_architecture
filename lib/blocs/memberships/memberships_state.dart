class MembershipsState {
  final Map<int, int>? membershipCart;
  final double? membershipTotalPrice;
  final bool? loading;

  MembershipsState({
    this.membershipCart,
    this.membershipTotalPrice,
    this.loading,
  });

  MembershipsState copyWith({
    Map<int, int>? membershipCart,
    double? membershipTotalPrice,
    bool? loading,
  }) {
    return MembershipsState(
      membershipCart: membershipCart ?? this.membershipCart,
      membershipTotalPrice: membershipTotalPrice ?? this.membershipTotalPrice,
      loading: loading ?? this.loading,
    );
  }
}

class MembershipSuccessState extends MembershipsState {
  final String? saleId;

  MembershipSuccessState({
    Map<int, int>? membershipCart,
    double? membershipTotalPrice,
    bool? loading,
    this.saleId,
  }) : super(
         membershipCart: membershipCart,
         membershipTotalPrice: membershipTotalPrice,
         loading: loading,
       );
}

class MembershipErrorState extends MembershipsState {
  MembershipErrorState({
    Map<int, int>? membershipCart,
    double? membershipTotalPrice,
    bool? loading,
  }) : super(
         membershipCart: membershipCart,
         membershipTotalPrice: membershipTotalPrice,
         loading: loading,
       );
}

class InitialMembershipState extends MembershipsState {
  InitialMembershipState()
    : super(membershipCart: {}, membershipTotalPrice: 0, loading: false);
}
