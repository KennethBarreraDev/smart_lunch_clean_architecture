import 'package:smart_lunch/data/models/session_data.dart';

abstract class SessionState {
  final bool obscurePassword;

  const SessionState({this.obscurePassword = true});
}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {
  const SessionLoading({super.obscurePassword});
}

class SessionAuthenticated extends SessionState {
  SessionData? sessionData;

  SessionAuthenticated({super.obscurePassword, required this.sessionData});
}

class SessionUnauthenticated extends SessionState {
  final String? error;

  const SessionUnauthenticated({this.error, super.obscurePassword});
}
