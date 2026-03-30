import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_event.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/cafeteria_hours/cafeteria_hours_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria_hours/cafeteria_hours_event.dart';
import 'package:smart_lunch/blocs/family/family_bloc.dart';
import 'package:smart_lunch/blocs/family/family_event.dart';
import 'package:smart_lunch/blocs/family/family_state.dart';
import 'package:smart_lunch/blocs/openpay/openpay_bloc.dart';
import 'package:smart_lunch/blocs/openpay/openpay_event.dart';
import 'package:smart_lunch/blocs/openpay/openpay_state.dart';
import 'package:smart_lunch/blocs/products/products_bloc.dart';
import 'package:smart_lunch/blocs/products/products_event.dart';
import 'package:smart_lunch/blocs/products/products_state.dart';
import 'package:smart_lunch/blocs/sales_history/sales_history_bloc.dart';
import 'package:smart_lunch/blocs/sales_history/sales_history_event.dart';
import 'package:smart_lunch/blocs/sales_history/sales_history_state.dart';
import 'package:smart_lunch/blocs/session/session_bloc.dart';
import 'package:smart_lunch/blocs/session/session_state.dart';
import 'package:smart_lunch/blocs/users/user_event.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/blocs/users/users_state.dart';
import 'package:smart_lunch/core/base_widgets/snackbar/app_snackbar.dart';
import 'package:smart_lunch/core/constants/countries.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class SessionLoaderListener extends StatelessWidget {
  final Widget child;
  final VoidCallback onUnauthenticatedSession;
  final bool loadOpepaySettings;
  final bool shouldNavigate;

  const SessionLoaderListener({
    super.key,
    required this.child,
    required this.onUnauthenticatedSession,
    this.loadOpepaySettings = true,
    this.shouldNavigate = true,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SessionBloc, SessionState>(
          listener: (context, state) {
            if (state is SessionAuthenticated) {
              context.read<CafeteriaBloc>().add(LoadCafeteria());
            } else if (state is SessionUnauthenticated) {
              onUnauthenticatedSession();
            }
          },
        ),

        BlocListener<CafeteriaBloc, CafeteriaState>(
          listener: (context, state) {
            if (state is CafeteriaSuccess) {
              context.read<UsersBloc>().add(
                LoadUsersEvent(
                  isPanama: Countries.isPanama(
                    state.selected.school?.country ?? "",
                  ),
                ),
              );
            }

            if (state is CafeteriaError) {
              AppSnackbar.show(state.message);
            }
          },
        ),

        BlocListener<UsersBloc, UsersState>(
          listener: (context, state) {
            if (state is UsersLoaded) {
              context.read<FamilyBloc>().add(LoadFamilyEvent());
            }

            if (state is UsersError) {
              AppSnackbar.show(state.message);
            }
          },
        ),

        BlocListener<FamilyBloc, FamilyState>(
          listener: (context, state) {
            if (state is FamilyLoaded) {
              final usersState = context.read<UsersBloc>().state;

              if (usersState is UsersLoaded) {
                context.read<SalesHistoryBloc>().add(
                  LoadSalesHistoryEvent(usersState.mainUser),
                );
              }
            }

            if (state is FamilyError) {
              AppSnackbar.show(state.message);
            }
          },
        ),

        BlocListener<SalesHistoryBloc, SalesHistoryState>(
          listener: (context, state) {
            if (state is SalesHistoryLoaded) {
              final cafeteriaState = context.read<CafeteriaBloc>().state;

              if (cafeteriaState is CafeteriaSuccess) {
                context.read<CafeteriaHoursBloc>().add(
                  UpdateCafeteriaHours(
                    DateTime.parse(cafeteriaState.cafeteriaSettings.endTime),
                    DateTime.parse(cafeteriaState.cafeteriaSettings.startTime),
                  ),
                );
                context.read<ProductsBloc>().add(
                  LoadProductsEvent(cafeteria: cafeteriaState.selected),
                );
              }
            }

            if (state is SalesHistoryError) {
              AppSnackbar.show(state.message);
            }
          },
        ),

        BlocListener<ProductsBloc, ProductsState>(
          listener: (context, state) {
            final cafeteriaState = context.read<CafeteriaBloc>().state;

            if (cafeteriaState is CafeteriaSuccess) {
              if ((cafeteriaState.cafeteriaSettings.openpayRecharge &&
                  loadOpepaySettings)) {
                context.read<OpenpayBloc>().add(ConfigureOpenpayEvent());
              } else {
                if (shouldNavigate) {
                  context.go(AppRoutes.homeRoute);
                }
              }
            }

            if (state is ProductsError) {
              AppSnackbar.show(state.message);
            }
          },
        ),

        BlocListener<OpenpayBloc, OpenpayState>(
          listener: (context, state) {
            if (state is OpenpayLoaded) {
              if (shouldNavigate) {
                context.go(AppRoutes.homeRoute);
              }
            }

            if (state is OpenpayError) {
              AppSnackbar.show(state.message);
            }
          },
        ),
      ],
      child: child,
    );
  }
}
