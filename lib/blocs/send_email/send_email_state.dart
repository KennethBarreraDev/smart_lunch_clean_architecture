abstract class SendEmailState {
  const SendEmailState();
}

class SendEmailInitial extends SendEmailState {}

class SendEmailLoading extends SendEmailState {}

class SendEmailSuccess extends SendEmailState {
  final String email;

  const SendEmailSuccess(this.email);
}

class SendEmailError extends SendEmailState {
  final String email;
  final String message;

  const SendEmailError(this.email, this.message);
}
