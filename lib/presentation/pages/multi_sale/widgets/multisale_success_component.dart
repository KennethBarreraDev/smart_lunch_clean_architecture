import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/multiple_sale/multiple_sale_bloc.dart';
import 'package:smart_lunch/blocs/multiple_sale/multiple_sale_state.dart'
    show MultipleSaleState, MultipleSaleSuccessState;

import 'package:smart_lunch/core/base_widgets/buttons/rounded_button.dart';
import 'package:smart_lunch/core/base_widgets/layouts/success_transaction_layout.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class MultipleSaleSuccessPage extends StatelessWidget {
  const MultipleSaleSuccessPage({super.key});

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
    return SuccessLayout(
      image: _successImage(),
      titles: _titles(context),
      content: _content(context),
    );
  }

  Widget _successImage() {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      width: 100.w,
      height: 18.h,
      alignment: Alignment.center,
      child: SizedBox(
        height: 150,
        child: SvgPicture.asset(
          AppImages.successfulSaleImage,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _titles(BuildContext context) {
    return SuccessTitles(
      title: AppLocalizations.of(context)!.order_completed,
      subtitle: AppLocalizations.of(context)!.purchase_successfully_mesage,
    );
  }

  Widget _content(BuildContext context) {
    return BlocBuilder<MultipleSaleBloc, MultipleSaleState>(
      builder: (context, state) {
        if (state is! MultipleSaleSuccessState) {
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

        final discountAmount = state.totalPrice - state.disscount;

        final finalTotal = state.totalPrice - discountAmount;

        return Container(
          margin: EdgeInsets.only(top: 40.h),
          width: 100.w,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _priceRow("Total", state.totalPrice, currency),

              if (state.applyDisscount) ...[
                _divider(),
                _priceRow("Descuento", -discountAmount, currency),
              ],

              _divider(),

              _priceRow("Total Final", finalTotal, currency, isTotal: true),

              const SizedBox(height: 20),

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
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          "\$${value.toStringAsFixed(2)} $currency",
          style: TextStyle(
            fontSize: isTotal ? 24 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Divider(color: AppColors.darkBlue.withValues(alpha: 0.15));
  }
}
