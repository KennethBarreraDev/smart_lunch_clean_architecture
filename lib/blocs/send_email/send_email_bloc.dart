import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/send_email/send_email_event.dart';
import 'package:smart_lunch/blocs/send_email/send_email_state.dart';
import 'package:smart_lunch/core/utils/exceptions_parser.dart';
import 'package:smart_lunch/data/repositories/send_email/send_email_repository.dart';

class SendEmailBloc extends Bloc<SendEmailEvent, SendEmailState> {
  final SendEmailRepository repository;

  SendEmailBloc(this.repository) : super(SendEmailInitial()) {
    on<SendVerificationEmail>(_onSendVerificationEmail);
  }

  Future<void> _onSendVerificationEmail(
    SendVerificationEmail event,
    Emitter<SendEmailState> emit,
  ) async {
    emit(SendEmailLoading());

    try {
      await repository.sendVerificationEmail(event.email);
      emit(SendEmailSuccess(event.email));
    } catch (e) {
      emit(SendEmailError(event.email, ExceptionsParser.getMessageFromException(e)));
    }
  }
}
