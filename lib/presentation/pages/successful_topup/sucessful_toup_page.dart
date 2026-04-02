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
import 'package:smart_lunch/core/base_widgets/layouts/success_transaction_layout.dart';
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

  @override
  Widget build(BuildContext context) {
    return SuccessLayout(
      image: _statusImage(),
      titles: _titles(context),
      content: _content(),
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

        return SuccessTitles(
          title: isSuccess
              ? AppLocalizations.of(context)!.successful_recharge
              : AppLocalizations.of(context)!.failed_recharge,
          subtitle:
              AppLocalizations.of(context)!.purchase_successfully_mesage,
        );
      },
    );
  }

  Widget _content() {
    return BlocBuilder<TopupBloc, TopupState>(
      builder: (context, state) {
        if (state is! TopupSuccessState) return const SizedBox.shrink();

        final cafeteriaState =
            context.select((CafeteriaBloc bloc) => bloc.state);

        if (cafeteriaState is! CafeteriaSuccess) {
          return const SizedBox.shrink();
        }

        final currency =
            cafeteriaState.selected.school?.currency ??
                CafeteriaConstants.defaultCurrency;

        final total = state.selectedRechargeAmount + state.commissionFee;

        return Container(
          margin: EdgeInsets.only(top: 40.h),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _priceRow(total, currency),
              const SizedBox(height: 10),
              _infoRow("Folio", state.transactionFolio),
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
                text: AppLocalizations.of(context)!.go_back_button,
                onTap: () => context.go(AppRoutes.homeRoute),
                color: AppColors.orange,
                iconData: Icons.arrow_back,
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
        const Text("Total"),
        Text("\$${total.toStringAsFixed(2)} $currency"),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Flexible(child: Text(value)),
      ],
    );
  }

  Widget _divider() => const Divider();
}