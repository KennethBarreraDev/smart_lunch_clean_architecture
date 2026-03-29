import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/family/family_bloc.dart';
import 'package:smart_lunch/blocs/family/family_state.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/blocs/users/users_state.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class TopupBalance extends StatelessWidget {
  const TopupBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, usersState) {
        if (usersState is! UsersLoaded) {
          return SizedBox();
        }

        return BlocBuilder<FamilyBloc, FamilyState>(
          builder: (context, familyState) {
            if (familyState is! FamilyLoaded) {
              return SizedBox();
            }

            double currentBalance =
                (familyState.balance) - (usersState.totalDebt);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    AppLocalizations.of(context)!.current_balance,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Text(
                  currentBalance < 0
                      ? "-\$${currentBalance.abs().toStringAsFixed(2)}"
                      : "\$${currentBalance.toStringAsFixed(2)}",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
