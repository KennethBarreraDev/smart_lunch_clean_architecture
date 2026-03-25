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

  UsersLoaded({
    required this.mainUser,
    required this.children,
    required this.debtUsers,
    required this.totalDebt
  });

}

class UsersError extends UsersState {
  final String message;

  UsersError(this.message);
}