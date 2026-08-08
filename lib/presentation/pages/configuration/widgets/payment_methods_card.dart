import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_lunch/blocs/session/session_bloc.dart';
import 'package:smart_lunch/blocs/session/session_state.dart';
import 'package:smart_lunch/core/constants/user_roles.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/configuration/widgets/settings_option_card.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class PaymentMethodsCard extends StatelessWidget {
  const PaymentMethodsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        if (state is! SessionAuthenticated) {
          return const SizedBox();
        }

        final userType = state.sessionData?.userType;
        final canSeePaymentMethods =
            userType == UserRole.tutor || userType == UserRole.teacher;

        if (!canSeePaymentMethods) {
          return const SizedBox();
        }

        return SettingsOptionCard(
          icon: Icons.credit_card,
          text: AppLocalizations.of(context)!.payment_methods_message,
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
            size: 28,
          ),
          onTap: () => context.push(AppRoutes.paymentInformation),
        );
      },
    );
  }
}
