import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/sales/sales_bloc.dart';
import 'package:smart_lunch/blocs/sales/sales_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/buttons/rounded_button.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/core/utils/date_utils.dart';
import 'package:smart_lunch/core/utils/sale_utils.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';
import 'package:vector_graphics/vector_graphics.dart';

class SuccessfulPreSalePage extends StatelessWidget {
  const SuccessfulPreSalePage({super.key});

  static const _titleStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static final _labelStyle = TextStyle(
    color: AppColors.darkBlue,
    fontWeight: FontWeight.w700,
    fontSize: 16.0,
  );

  static final _valueStyle = TextStyle(
    color: AppColors.darkBlue,
    fontSize: 16.0,
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
                _successImage(),
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

  Widget _successImage() {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      width: 100.w,
      height: 18.h,
      alignment: Alignment.center,
      child: SizedBox(
        height: 150,
        child: SvgPicture(
          AssetBytesLoader(AppImages.successfulSaleImage),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

   Widget _titles(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.order_completed,
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
  }

  Widget _content() {
    return BlocBuilder<SalesBloc, SaleState>(
      builder: (context, saleState) {
        if (saleState is! SaleSuccessState) {
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

        final user = saleState.selectedUser;

        return Container(
          margin: EdgeInsets.only(top: 40.h),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _infoCard(context, saleState, currency, user),
              const SizedBox(height: 30),
              _backButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _infoCard(
    BuildContext context,
    SaleSuccessState state,
    String currency,
    dynamic user,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tuitionGreen.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.tuitionGreen, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Column(
        children: [
          _richText(context, state, user),
          const SizedBox(height: 11),
          _divider(),
          const SizedBox(height: 11),
          _totalRow(state.finalPrice, currency),
        ],
      ),
    );
  }

  Widget _richText(BuildContext context, SaleSuccessState state, dynamic user) {
    final folio = SaleUtils.formatFolio(state.saleId);
    final date = SaleUtils.formatDeliveryDate(state);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: AppLocalizations.of(context)!.the_order,
            style: _valueStyle,
          ),
          TextSpan(text: folio, style: _labelStyle),
          TextSpan(
            text: AppLocalizations.of(context)!.will_be_ready_message,
            style: _valueStyle,
          ),
          TextSpan(
            text:
                "${user?.user?.firstName ?? ""} ${user?.user?.lastName ?? ""}",
            style: _labelStyle,
          ),
          TextSpan(
            text: AppLocalizations.of(context)!.on_message,
            style: _valueStyle,
          ),
          TextSpan(text: date, style: _labelStyle),
        ],
      ),
    );
  }

  Widget _totalRow(String? price, String currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Total", style: _labelStyle.copyWith(fontSize: 24)),
        Text(
          "\$${price ?? "0"} $currency",
          style: _valueStyle.copyWith(fontSize: 24),
        ),
      ],
    );
  }

  Widget _divider() {
    return DottedLine(
      dashColor: Colors.black.withValues(alpha: 0.15),
      dashGapLength: 6,
      dashLength: 6,
    );
  }

  Widget _backButton(BuildContext context) {
    return RoundedButton(
      color: AppColors.orange,
      iconData: Icons.arrow_back,
      text: AppLocalizations.of(context)!.go_back_button,
      onTap: () => context.go(AppRoutes.homeRoute),
    );
  }
}
