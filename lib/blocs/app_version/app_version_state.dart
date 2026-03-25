

abstract class AppVersionState {}

class AppVersionInitialState extends AppVersionState {}

class AppVersionLoading extends AppVersionState {}

class LastAppVersion extends AppVersionState {}

class AppNotUpdated extends AppVersionState {}

class AppVersionError extends AppVersionState {
  final String message;
  AppVersionError(this.message);
}
