abstract class SessionEvent {}

class CheckSessionEvent extends SessionEvent {}

class LoginUserEvent extends SessionEvent {
  final String username;
  final String password;

  LoginUserEvent(this.username, this.password);
}

class TogglePasswordVisibility extends SessionEvent {}