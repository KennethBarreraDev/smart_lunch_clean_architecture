import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/family/family_bloc.dart';
import 'package:smart_lunch/blocs/family/family_state.dart';
import 'package:smart_lunch/blocs/openpay/openpay_bloc.dart';
import 'package:smart_lunch/blocs/openpay/openpay_state.dart';
import 'package:smart_lunch/blocs/products/products_bloc.dart';
import 'package:smart_lunch/blocs/products/products_state.dart';
import 'package:smart_lunch/blocs/sales_history/sales_history_bloc.dart';
import 'package:smart_lunch/blocs/sales_history/sales_history_state.dart';
import 'package:smart_lunch/blocs/session/session_bloc.dart';
import 'package:smart_lunch/blocs/session/session_state.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/blocs/users/users_state.dart';

class SessionLoadingBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, bool isLoading) builder;

  const SessionLoadingBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {

    final sessionLoading =
        context.select((SessionBloc bloc) => bloc.state is SessionLoading);

    final cafeteriaLoading =
        context.select((CafeteriaBloc bloc) => bloc.state is CafeteriaLoading);

    final usersLoading =
        context.select((UsersBloc bloc) => bloc.state is UsersLoading);

    final familyLoading =
        context.select((FamilyBloc bloc) => bloc.state is FamilyLoading);

    final salesLoading =
        context.select((SalesHistoryBloc bloc) => bloc.state is SalesHistoryLoading);

    final productsLoading =
        context.select((ProductsBloc bloc) => bloc.state is ProductsLoading);

    final openpayLoading =
        context.select((OpenpayBloc bloc) => bloc.state is OpenpayLoading);

    final isLoading = sessionLoading ||
        cafeteriaLoading ||
        usersLoading ||
        familyLoading ||
        salesLoading ||
        productsLoading ||
        openpayLoading;

    return builder(context, isLoading);
  }
}