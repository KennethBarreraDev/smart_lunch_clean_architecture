import 'package:smart_lunch/data/models/cafeteria_user_model.dart';

abstract class SelectedUserState {}

class SelectedUserInitial extends SelectedUserState {}

class SelectedUserLoading extends SelectedUserState {}

class SelectedUserLoaded extends SelectedUserState {
  final int cafeteriaUserId;
  SelectedUserLoaded({required this.cafeteriaUserId});
}

class SelectedUserDataLoaded extends SelectedUserState {
  final CafeteriaUser userData;
  SelectedUserDataLoaded({required this.userData});
}

class SelectedUserError extends SelectedUserState {
  final String message;
  SelectedUserError(this.message);
}

class SelectedUserUpdating extends SelectedUserState {}

class SelectedUserUpdated extends SelectedUserState {
  final Map<String, dynamic> updatedUserData;

  SelectedUserUpdated({required this.updatedUserData});
}
