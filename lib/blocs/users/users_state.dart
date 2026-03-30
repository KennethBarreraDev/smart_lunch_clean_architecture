import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/user_model.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final CafeteriaUser mainUser;
  final List<CafeteriaUser> children;
  final List<UserModel> debtUsers;
  final double totalDebt;
  final bool hasPendingUserMemberships;
  final List<CafeteriaUser> pendingUserMemberships;
  final bool showMembershipModal;

  UsersLoaded({
    required this.mainUser,
    required this.children,
    required this.debtUsers,
    required this.totalDebt,
    required this.hasPendingUserMemberships,
    required this.pendingUserMemberships,
    required this.showMembershipModal,
  });

  UsersLoaded copyWith({
    CafeteriaUser? mainUser,
    List<CafeteriaUser>? children,
    List<UserModel>? debtUsers,
    double? totalDebt,
    bool? hasPendingUserMemberships,
    List<CafeteriaUser>? pendingUserMemberships,
    bool? showMembershipModal,
  }) {
    return UsersLoaded(
      mainUser: mainUser ?? this.mainUser,
      children: children ?? this.children,
      debtUsers: debtUsers ?? this.debtUsers,
      totalDebt: totalDebt ?? this.totalDebt,
      hasPendingUserMemberships:
          hasPendingUserMemberships ?? this.hasPendingUserMemberships,
      pendingUserMemberships:
          pendingUserMemberships ?? this.pendingUserMemberships,
      showMembershipModal:
          showMembershipModal ?? this.showMembershipModal,
    );
  }
}

class UsersError extends UsersState {
  final String message;

  UsersError(this.message);
}
