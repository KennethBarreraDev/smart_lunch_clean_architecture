import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/auth/widgets/login_base_page.dart';
import 'package:smart_lunch/presentation/pages/auth/widgets/login_button.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class CheckEmailPage extends StatelessWidget {
  const CheckEmailPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return LoginBasePage(
      title: localizations.check_email,
      fillHeight: true,
      headerImage: Image.asset(AppImages.emailVerification, height: 90),
      bodyConsumer: Column(
        children: [
          Text(
            "${localizations.send_email_message}$email,${localizations.click_link}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff323232),
              fontWeight: FontWeight.w300,
              fontSize: 14.0,
              fontFamily: "Comfortaa",
            ),
          ),

          SizedBox(height: 2.h),

          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "${localizations.note}: ",
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: localizations.check_spam_message),
              ],
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff323232),
              fontWeight: FontWeight.w300,
              fontSize: 14.0,
              fontFamily: "Comfortaa",
            ),
          ),

          SizedBox(height: 3.h),

          LoginButton(
            text: localizations.go_back_button,
            isEnabled: true,
            isLoading: false,
            onPressed: () => context.go(AppRoutes.authRoute),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
