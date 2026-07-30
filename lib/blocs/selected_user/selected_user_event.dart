abstract class SelectedUserEvent {}

class ClearSelectedUser extends SelectedUserEvent {}

class SelectUser extends SelectedUserEvent {
  final int cafeteriaUserId;
  SelectUser({required this.cafeteriaUserId});
}

class LoadSelectedUserData extends SelectedUserEvent {
  final int cafeteriaUserId;
  LoadSelectedUserData({required this.cafeteriaUserId});
}

class UpdateSelectedUser extends SelectedUserEvent {
  final int cafeteriaUserId;
  final Map<String, dynamic> updatedData;

  UpdateSelectedUser({
    required this.cafeteriaUserId,
    required this.updatedData,
  });
}
