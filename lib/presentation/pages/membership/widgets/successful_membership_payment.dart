import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import 'package:smart_lunch/blocs/memberships/memberships_bloc.dart';
import 'package:smart_lunch/blocs/memberships/memberships_state.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';

import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/buttons/rounded_button.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';

import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';

import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class MembershipSuccessPage extends StatelessWidget {
  const MembershipSuccessPage({super.key});

  static const _titleStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static final _labelStyle = TextStyle(
    color: AppColors.darkBlue,
    fontWeight: FontWeight.w700,
    fontSize: 15.0,
    fontFamily: "Comfortaa",
  );

  static final _valueStyle = TextStyle(
    color: AppColors.darkBlue,
    fontSize: 13.0,
    fontFamily: "Comfortaa",
  );

  @override
  Widget build(BuildContext context) {
    return TransparentScaffold(
      selectedOption: "Inicio",
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                _header(),
                _statusImage(),
                _titles(context),
                _content(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return CustomAppBar(
      height: 38.h,
      showPageTitle: false,
      showDrawer: false,
      image: AppImages.appBarLongImg,
      titleTopPadding: 0.3,
      secondaryColor: true,
    );
  }

  Widget _statusImage() {
    return BlocBuilder<MembershipsBloc, MembershipsState>(
      builder: (context, state) {
        final isSuccess = state is MembershipSuccessState &&
            state.transactionStatus == "APPROVED";

        return Container(
          margin: EdgeInsets.only(top: 15.h),
          width: 100.w,
          height: 18.h,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            isSuccess
                ? AppImages.successRecharge
                : AppImages.errorRecharge,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  Widget _titles(BuildContext context) {
    return BlocBuilder<MembershipsBloc, MembershipsState>(
      builder: (context, state) {
        final isSuccess = state is MembershipSuccessState &&
            state.transactionStatus == "APPROVED";

        return Container(
          margin: EdgeInsets.only(top: 5.h),
          child: Column(
            children: [
              Text(
                isSuccess
                    ? AppLocalizations.of(context)!.payment_completed
                    : AppLocalizations.of(context)!.try_again_later,
                style: _titleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!
                    .purchase_successfully_mesage,
                style: _titleStyle.copyWith(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.75),
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _content(BuildContext context) {
    return BlocBuilder<MembershipsBloc, MembershipsState>(
      builder: (context, state) {
        if (state is! MembershipSuccessState) {
          return const SizedBox.shrink();
        }

        final cafeteriaState = context.select(
          (CafeteriaBloc bloc) => bloc.state,
        );

        if (cafeteriaState is! CafeteriaSuccess) {
          return const SizedBox.shrink();
        }

        final currency =
            cafeteriaState.selected.school?.currency ??
                CafeteriaConstants.defaultCurrency;

        final subtotal = state.membershipTotalPrice ?? 0.0; 
        final fee = subtotal * CafeteriaConstants.croemFee/100;
        final total = subtotal + fee;

        return Container(
          margin: EdgeInsets.only(top: 40.h),
          width: 100.w,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _priceRow(
                AppLocalizations.of(context)!.subtotal,
                subtotal,
                currency,
              ),

              const SizedBox(height: 10),

              _priceRow(
                AppLocalizations.of(context)!.bank_fee,
                fee,
                currency,
              ),

              _divider(),

              _priceRow(
                AppLocalizations.of(context)!.total_price,
                total,
                currency,
                isTotal: true,
              ),

              const SizedBox(height: 20),

              ..._buildUsers(state, currency),

              const SizedBox(height: 30),

              RoundedButton(
                color: AppColors.orange,
                iconData: Icons.arrow_back,
                text: AppLocalizations.of(context)!.go_back_button,
                onTap: () => context.go(AppRoutes.homeRoute),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildUsers(
      MembershipSuccessState state, String currency) {
    return (state.membershipCart ?? {}).entries.map((entry) {
      final quantity = entry.value;

      final price =
          quantity * CafeteriaConstants.panamaMembershipPrice;

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.darkBlue.withValues(alpha: 0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "User ID: ${entry.key} x$quantity",
              style: _labelStyle,
            ),
            Text(
              "\$${price.toStringAsFixed(2)} $currency",
              style: _valueStyle,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _priceRow(
    String label,
    double value,
    String currency, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: _labelStyle.copyWith(
            fontSize: isTotal ? 20 : 15,
          ),
        ),
        Text(
          "\$${value.toStringAsFixed(2)} $currency",
          style: _valueStyle.copyWith(
            fontSize: isTotal ? 24 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Divider(
      color: AppColors.darkBlue.withValues(alpha: 0.15),
    );
  }
}