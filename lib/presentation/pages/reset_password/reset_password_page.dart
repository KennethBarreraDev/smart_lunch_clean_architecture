import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/send_email/send_email_bloc.dart';
import 'package:smart_lunch/blocs/send_email/send_email_event.dart';
import 'package:smart_lunch/blocs/send_email/send_email_state.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/auth/widgets/login_base_page.dart';
import 'package:smart_lunch/presentation/pages/auth/widgets/login_button.dart';
import 'package:smart_lunch/presentation/pages/auth/widgets/login_input.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  late final SendEmailBloc _sendEmailBloc;

  static final RegExp _emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool _showEmailError = false;

  bool get _isEmailValid => _emailRegExp.hasMatch(emailController.text.trim());

  void _onSendPressed(BuildContext context) {
    if (!_isEmailValid) {
      _sendEmailBloc.add(const ResetSendEmailState());
      setState(() => _showEmailError = true);
      return;
    }

    setState(() => _showEmailError = false);

    _sendEmailBloc.add(SendVerificationEmail(emailController.text.trim()));
  }

  String _errorMessageFor(String code, AppLocalizations localizations) {
    switch (code) {
      case "validation_error":
        return localizations.send_email_validation_error;
      case "internal_server_error":
        return localizations.send_email_server_error;
      default:
        return localizations.send_email_generic_error;
    }
  }

  Widget _buildEmailErrorBox(AppLocalizations localizations) {
    String? errorText;

    if (_showEmailError) {
      errorText = localizations.invalid_email_field;
    }

    return BlocBuilder<SendEmailBloc, SendEmailState>(
      builder: (context, state) {
        errorText ??= state is SendEmailError
            ? _errorMessageFor(state.message, localizations)
            : null;

        if (errorText == null) {
          return const SizedBox();
        }

        return Padding(
          padding: EdgeInsets.only(top: 0.5.h),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xffef5360).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                errorText!,
                style: const TextStyle(
                  color: Color(0xffef5360),
                  fontSize: 12.0,
                  fontFamily: "Comfortaa",
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _sendEmailBloc = context.read<SendEmailBloc>();
    _sendEmailBloc.add(const ResetSendEmailState());
  }

  @override
  void dispose() {
    _sendEmailBloc.add(const ResetSendEmailState());
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<SendEmailBloc, SendEmailState>(
      listener: (context, state) {
        if (state is SendEmailSuccess) {
          context.push(AppRoutes.checkEmailRoute, extra: state.email);
        }
      },
      child: LoginBasePage(
        title: localizations.password_recover,
        fillHeight: true,
        bodyConsumer: Column(
          children: [
            LoginInput(
              labelText: localizations.email,
              textInputType: TextInputType.emailAddress,
              textEditingController: emailController,
              onChange: (_) {
                if (_showEmailError) {
                  setState(() => _showEmailError = false);
                }
              },
            ),

            _buildEmailErrorBox(localizations),

            SizedBox(height: 3.h),

            BlocBuilder<SendEmailBloc, SendEmailState>(
              builder: (context, state) {
                final isLoading = state is SendEmailLoading;
                return LoginButton(
                  text: localizations.send_button,
                  isEnabled: !isLoading,
                  isLoading: isLoading,
                  onPressed: () => _onSendPressed(context),
                );
              },
            ),

            SizedBox(height: 2.h),

            Center(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Text(
                  localizations.go_back_button,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Color(0xff323232),
                    fontWeight: FontWeight.w300,
                    fontSize: 12.0,
                    fontFamily: "Comfortaa",
                  ),
                ),
              ),
            ),

            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }
}
