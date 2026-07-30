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
  final List<CafeteriaUser>? familyChildren;

  UsersLoaded({
    required this.mainUser,
    required this.children,
    required this.debtUsers,
    required this.totalDebt,
    required this.hasPendingUserMemberships,
    required this.pendingUserMemberships,
    required this.showMembershipModal,
    this.familyChildren,
  });

  UsersLoaded copyWith({
    CafeteriaUser? mainUser,
    List<CafeteriaUser>? children,
    List<UserModel>? debtUsers,
    double? totalDebt,
    bool? hasPendingUserMemberships,
    List<CafeteriaUser>? pendingUserMemberships,
    bool? showMembershipModal,
    List<CafeteriaUser>? familyChildren,
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
      showMembershipModal: showMembershipModal ?? this.showMembershipModal,
      familyChildren: familyChildren ?? this.familyChildren,
    );
  }
}

class UsersError extends UsersState {
  final String message;

  UsersError(this.message);
}

class UsersEmpty extends UsersState {
  final String message;

  UsersEmpty({this.message = 'No hay usuarios disponibles'});
}

class FamilyChildrenLoading extends UsersState {
  final CafeteriaUser? mainUser;

  FamilyChildrenLoading({this.mainUser});
}

class FamilyChildrenLoaded extends UsersState {
  final List<CafeteriaUser> familyChildren;
  final CafeteriaUser? mainUser;

  FamilyChildrenLoaded({required this.familyChildren, this.mainUser});
}
