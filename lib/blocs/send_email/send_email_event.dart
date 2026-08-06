abstract class SendEmailEvent {
  const SendEmailEvent();
}

class SendVerificationEmail extends SendEmailEvent {
  final String email;

  const SendVerificationEmail(this.email);
}

class ResetSendEmailState extends SendEmailEvent {
  const ResetSendEmailState();
}
