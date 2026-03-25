import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/session/session_event.dart';
import 'package:smart_lunch/blocs/session/session_state.dart';
import 'package:smart_lunch/core/utils/exceptions_parser.dart';
import 'package:smart_lunch/data/repositories/session/session_repository.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final SessionRepository sessionRepository;

  SessionBloc({required this.sessionRepository}) : super(SessionInitial()) {
    on<CheckSessionEvent>(_checkSession);
    on<TogglePasswordVisibility>(_togglePassword);
    on<LoginUserEvent>(_loginUser);
  }

  Future<void> _checkSession(
    CheckSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());

    try {
      bool isValid = await sessionRepository.checkAndLoadSession();

      if (isValid) {
        emit(SessionAuthenticated(
          obscurePassword: state.obscurePassword,
          sessionData: sessionRepository.session,
        ));
      } else {
        emit(
          SessionUnauthenticated(
            obscurePassword: state.obscurePassword,
            error: null,
          ),
        );
      }
    } catch (e) {
      developer.log("Error checking session: $e");
      emit(
        SessionUnauthenticated(
          obscurePassword: state.obscurePassword,
          error: null,
        ),
      );
    }
  }

  void _togglePassword(
    TogglePasswordVisibility event,
    Emitter<SessionState> emit,
  ) {
    final newValue = !state.obscurePassword;

    emit(SessionUnauthenticated(obscurePassword: newValue));
  }

  Future<void> _loginUser(
    LoginUserEvent event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading(obscurePassword: state.obscurePassword));

    try {
      bool isValid = await sessionRepository.loginUserWithCredentials(
        event.username,
        event.password,
      );

      if (isValid) {
        emit(SessionAuthenticated(
          obscurePassword: state.obscurePassword,
          sessionData: sessionRepository.session
          ));
      } else {
        emit(
          SessionUnauthenticated(
            obscurePassword: state.obscurePassword,
            error: "invalid_credentials",
          ),
        );
      }
    } catch (e) {
      developer.log("Error while loggin user: $e");
      emit(
        SessionUnauthenticated(
          obscurePassword: state.obscurePassword,
          error: ExceptionsParser.getMessageFromException(e),
        ),
      );
    }
  }
}
