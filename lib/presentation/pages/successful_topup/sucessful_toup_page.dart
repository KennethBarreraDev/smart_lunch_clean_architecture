import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/topup/topup_bloc.dart';
import 'package:smart_lunch/blocs/topup/topup_state.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/buttons/rounded_button.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/core/utils/date_utils.dart';
import 'package:smart_lunch/core/utils/payment_method_utils.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class TopupSuccessPage extends StatelessWidget {
  const TopupSuccessPage({super.key});

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
                _content(),
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
    return BlocBuilder<TopupBloc, TopupState>(
      builder: (context, state) {
        final isSuccess =
            state is TopupSuccessState && state.transactionStatus == "APPROVED";

        return Container(
          margin: EdgeInsets.only(top: 15.h),
          width: 100.w,
          height: 18.h,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            isSuccess ? AppImages.successRecharge : AppImages.errorRecharge,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  Widget _titles(BuildContext context) {
    return BlocBuilder<TopupBloc, TopupState>(
      builder: (context, state) {
        final isSuccess =
            state is TopupSuccessState && state.transactionStatus == "APPROVED";

        return Container(
          margin: EdgeInsets.only(top: 5.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isSuccess
                        ? AppLocalizations.of(context)!.successful_recharge
                        : AppLocalizations.of(context)!.failed_recharge,
                    style: _titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.purchase_successfully_mesage,
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

  Widget _content() {
    return BlocBuilder<TopupBloc, TopupState>(
      builder: (context, state) {
        if (state is! TopupSuccessState) {
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

        final total = state.selectedRechargeAmount + state.commissionFee;

        return Container(
          margin: EdgeInsets.only(top: 40.h),
          width: 100.w,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _priceRow(total, currency),

              const SizedBox(height: 10),

              _infoRow("Folio", _formatFolio(state.transactionFolio)),

              _divider(),

              _infoRow(
                AppLocalizations.of(context)!.date,
                CustomDateUtils.formatDateWithMinutes(DateTime.now()),
              ),

              _divider(),

              _infoRow(
                AppLocalizations.of(context)!.payment_method,
                PaymentMethodUtils.getMethodName(state.selectedMethod),
              ),

              _divider(),

              _infoRow("Transaction ID", state.topUpId ?? "-"),

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

  Widget _priceRow(double total, String currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Total", style: _labelStyle.copyWith(fontSize: 22)),
        Text(
          "\$${total.toStringAsFixed(2)} $currency",
          style: _valueStyle.copyWith(fontSize: 26),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: _labelStyle),
          Flexible(
            child: Text(
              value,
              style: _valueStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: AppColors.darkBlue.withValues(alpha: 0.15));
  }

  String _formatFolio(String folio) {
    if (folio.length <= 12) return folio;
    return folio.substring(folio.length - 12);
  }
}
