import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/session/session_bloc.dart';
import 'package:smart_lunch/blocs/session/session_event.dart';
import 'package:smart_lunch/blocs/session/session_state.dart';
import 'package:smart_lunch/core/base_widgets/generic_error_alert.dart';
import 'package:smart_lunch/core/base_widgets/session/session_loader_builder.dart';
import 'package:smart_lunch/core/base_widgets/session/session_loader_listener.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/auth/widgets/login_base_page.dart';
import 'package:smart_lunch/presentation/pages/auth/widgets/login_button.dart';
import 'package:smart_lunch/presentation/pages/auth/widgets/login_input.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SessionLoaderListener(
      onUnauthenticatedSession: () {},
      child: LoginBasePage(
        title: AppLocalizations.of(context)!.login,
        bodyConsumer: Column(
          children: [
            LoginInput(
              labelText: AppLocalizations.of(context)!.email,
              textInputType: TextInputType.emailAddress,
              textEditingController: emailController,
            ),

            SizedBox(height: 3.h),

            BlocBuilder<SessionBloc, SessionState>(
              buildWhen: (previous, current) =>
                  previous.obscurePassword != current.obscurePassword,
              builder: (context, state) {
                return LoginInput(
                  labelText: AppLocalizations.of(context)!.password,
                  textInputType: TextInputType.visiblePassword,
                  obscurePassword: state.obscurePassword,
                  onVisibilityChange: () {
                    context.read<SessionBloc>().add(TogglePasswordVisibility());
                  },
                  textEditingController: passwordController,
                );
              },
            ),

            SizedBox(height: 3.h),

            BlocBuilder<SessionBloc, SessionState>(
              builder: (context, state) {
                if (state is! SessionUnauthenticated || state.error == null) {
                  return const SizedBox();
                }

                return Container(
                  color: AppColors.coral.withValues(alpha: 0.25),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  margin: const EdgeInsets.only(top: 24),
                  child: GenericErrorAlert(error: state.error ?? ""),
                );
              },
            ),

            SizedBox(height: 3.h),

            SessionLoadingBuilder(
              builder: (context, isLoading) {
                return LoginButton(
                  text: AppLocalizations.of(context)!.login,
                  isEnabled: !isLoading,
                  isLoading: isLoading,
                  onPressed: () {
                    context.read<SessionBloc>().add(
                      LoginUserEvent(
                        emailController.text,
                        passwordController.text,
                      ),
                    );
                  },
                );
              },
            ),

            SizedBox(height: 2.h),

            Center(
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  AppLocalizations.of(context)!.reset_password,
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

            SizedBox(height: 2.h),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.go(AppRoutes.termsAndConditionsRoute);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.terms_and_conditions,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color(0xff323232),
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                        fontFamily: "Comfortaa",
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      context.go(AppRoutes.privacyPolicyRoute);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.political_privacy,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color(0xff323232),
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                        fontFamily: "Comfortaa",
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            Center(
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  AppLocalizations.of(context)!.contact,
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
