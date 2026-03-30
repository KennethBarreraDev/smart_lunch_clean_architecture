import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/repositories/topup/topup_repository.dart';
import 'memberships_event.dart';
import 'memberships_state.dart';

class MembershipsBloc extends Bloc<MembershipsEvent, MembershipsState> {
  final TopupRepository repository;

  MembershipsBloc(this.repository) : super(InitialMembershipState()) {
    on<AddUserToMembershipToPayment>(_addUserToMembershipToPayment);
    on<RemoveUserFromMembershipPayment>(_removeUserFromMembershipPayment);
    on<IsLoadingMemberships>(_isLoadingMemberships);
    on<ResetMemberships>(_resetMemberships);
    on<PayMemberships>(_payMemberships);
    on<FillInitialMemberships>(_fillInitialMemberships);
  }

  void _isLoadingMemberships(
    IsLoadingMemberships event,
    Emitter<MembershipsState> emit,
  ) {
    emit(state.copyWith(loading: event.isLoading));
  }

  void _addUserToMembershipToPayment(
    AddUserToMembershipToPayment event,
    Emitter<MembershipsState> emit,
  ) {
    final CafeteriaUser user = event.user;
    double membershipsTotal = state.membershipTotalPrice ?? 0;

    final newCart = Map<int, int>.from(state.membershipCart ?? {});

    if (newCart.containsKey(user.id)) {
      if ((newCart[user.id] ?? 0) < 12) {
        newCart[user.id ?? 0] = newCart[user.id]! + 1;
      }
      membershipsTotal += CafeteriaConstants.panamaMembershipPrice;
    } else {
      newCart[user.id ?? 0] = 1;
      membershipsTotal += CafeteriaConstants.panamaMembershipPrice;
    }

    emit(
      state.copyWith(
        membershipCart: newCart,
        membershipTotalPrice: membershipsTotal,
        loading: false,
      ),
    );
  }

  void _removeUserFromMembershipPayment(
    RemoveUserFromMembershipPayment event,
    Emitter<MembershipsState> emit,
  ) {
    final CafeteriaUser user = event.user;

    final newCart = Map<int, int>.from(state.membershipCart ?? {});

    if (!newCart.containsKey(user.id)) return;

    newCart[user.id ?? 0] = newCart[user.id]! - 1;

    if (newCart[user.id]! <= 0) {
      newCart.remove(user.id);
    }

    final newTotalPrice =
        (state.membershipTotalPrice ?? 0) -
        CafeteriaConstants.panamaMembershipPrice;

    emit(
      state.copyWith(
        membershipCart: newCart,
        membershipTotalPrice: newTotalPrice,
        loading: false,
      ),
    );
  }

  void _fillInitialMemberships(
    FillInitialMemberships event,
    Emitter<MembershipsState> emit,
  ) {
    final List<CafeteriaUser> users = event.users;
    final Map<int, int> newCart = {};
    double membershipsTotal = 0;

    users.forEach((users) {
      newCart[users.id ?? 0] = 1;
      membershipsTotal += CafeteriaConstants.panamaMembershipPrice;
    });

    emit(
      state.copyWith(
        membershipCart: newCart,
        membershipTotalPrice: membershipsTotal,
        loading: false,
      ),
    );
  }

  Future<void> _payMemberships(
    PayMemberships event,
    Emitter<MembershipsState> emit,
  ) async {
    final Map<int, int>? membershipCart = event.membershipCart;
    final double? membershipTotalPrice = event.membershipTotalPrice;
    final bool? loading = event.loading;
    emit(state);
  }

  void _resetMemberships(
    ResetMemberships event,
    Emitter<MembershipsState> emit,
  ) {
    emit(InitialMembershipState());
  }
}
