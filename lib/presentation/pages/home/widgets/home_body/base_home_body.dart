import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_lunch/blocs/products/products_bloc.dart';
import 'package:smart_lunch/blocs/products/products_event.dart';
import 'package:smart_lunch/blocs/sales/sales_bloc.dart';
import 'package:smart_lunch/blocs/sales/sales_event.dart';

import 'package:smart_lunch/core/constants/user_roles.dart';
import 'package:smart_lunch/core/utils/unrestricted_mode.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/cafeteria_setting_model.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/presale_model.dart';
import 'package:smart_lunch/data/models/session_data.dart';
import 'package:smart_lunch/presentation/pages/home/widgets/home_body/regular_home_body.dart';
import 'package:smart_lunch/presentation/pages/home/widgets/home_body/special_home_body.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class BaseHomeBody extends StatelessWidget {
  BaseHomeBody({
    super.key,
    required this.cafeteriaUser,
    required this.cafeteria,
    required this.cafeteriaSetting,
    required this.sessionData,
    required this.presales,
    required this.dailySales,
    required this.children,
  });

  List<CafeteriaUser> children;
  CafeteriaUser? cafeteriaUser;
  CafeteriaSetting? cafeteriaSetting;
  Cafeteria? cafeteria;
  SessionData? sessionData;
  List<Presale> presales = [];
  List<Presale> dailySales = [];

  @override
  Widget build(BuildContext context) {
    void onMenuTap() {}

    void onSaleTap() {
      DateTime now = DateTime.now();

      context.read<SalesBloc>().add(ResetSaleEvent());
      if (children.isNotEmpty) {
        context.read<SalesBloc>().add(ChangeSaleUser(children.first));
        context.read<SalesBloc>().add(ChangeSaleDate(now));
      }
      context.read<ProductsBloc>().add(ResetProductsEvent());

      context.read<ProductsBloc>().add(
        LoadProductsEvent(
          cafeteria: cafeteria!,
          userSelectedDate: now,
          omitFilters: UnrestrictedMode.value,
          isPresale: false,
        ),
      );
      context.pushNamed(
        AppRoutes.getCleanRouteName(AppRoutes.saleRoute),
        extra: false,
      );
    }

    void onPresaleTap() {
      context.read<SalesBloc>().add(ResetSaleEvent());
      if (children.isNotEmpty) {
        context.read<SalesBloc>().add(ChangeSaleUser(children.first));
        context.read<SalesBloc>().add(ChangeSaleDate(null));
      }
      context.read<ProductsBloc>().add(ResetProductsEvent());
      context.pushNamed(
        AppRoutes.getCleanRouteName(AppRoutes.saleRoute),
        extra: true,
      );
    }

    void onMultisaleTap() {
      context.pushNamed(
        AppRoutes.getCleanRouteName(AppRoutes.multisalePage),
      );
    }

    return (cafeteriaUser?.selfSufficient ??
            false || sessionData?.userType == UserRole.teacher)
        ? SpecialHomeBody(
            cafeteriaUser: cafeteriaUser,
            cafeteria: cafeteria,
            cafeteriaSetting: cafeteriaSetting,
            sessionData: sessionData,
            presales: presales,
            dailySales: dailySales,
            onMenuTap: onMenuTap,
            onSaleTap: onSaleTap,
            onPresaleTap: onPresaleTap,
            onMultisaleTap: onMultisaleTap,
          )
        : RegularHomeBody(
            cafeteriaUser: cafeteriaUser,
            cafeteria: cafeteria,
            cafeteriaSetting: cafeteriaSetting,
            sessionData: sessionData,
            presales: presales,
            dailySales: dailySales,
            onMenuTap: onMenuTap,
            onSaleTap: onSaleTap,
            onPresaleTap: onPresaleTap,
            onMultisaleTap: onMultisaleTap,
          );
  }
}
