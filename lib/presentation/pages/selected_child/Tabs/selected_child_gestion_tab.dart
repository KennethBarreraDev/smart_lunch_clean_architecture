import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_bloc.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_state.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/allergy/update_alergy_modal.dart';
import 'package:smart_lunch/presentation/pages/selected_child/widget/update_daily_limit_modal.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class SelectedChildGestionTab extends StatelessWidget {
  const SelectedChildGestionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((SelectedUserBloc bloc) {
      final state = bloc.state;
      if (state is SelectedUserDataLoaded) {
        return state.userData;
      }
      return null;
    });

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          leading: const Icon(Icons.attach_money, color: Colors.green),
          title: Text(
            '${AppLocalizations.of(context)!.daily_limit} (\$${user.dailyLimit ?? '0.00'} )',
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => UpdateDailyLimitModal(),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.warning_amber_rounded, color: Colors.amber),
          title: Text(AppLocalizations.of(context)!.allergies_message),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) =>
                  UpdateAlergyModal(initialAlergies: user.customAllergy ?? ''),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.block, color: Colors.red),
          title: Text(AppLocalizations.of(context)!.forbidden_products),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            context.push(AppRoutes.productRestriction);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.production_quantity_limits_rounded,
            color: Colors.deepOrange,
          ),
          title: Text(AppLocalizations.of(context)!.limited_products),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            context.push(AppRoutes.productLimited);
          },
        ),
      ],
    );
  }
}
