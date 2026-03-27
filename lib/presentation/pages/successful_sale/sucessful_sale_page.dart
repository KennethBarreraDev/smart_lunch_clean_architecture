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
import 'package:smart_lunch/core/utils/allowed_users.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/core/utils/date_utils.dart';
import 'package:smart_lunch/core/utils/sale_utils.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';
import 'package:vector_graphics/vector_graphics.dart';

class SuccessfulSalePage extends StatelessWidget {
  const SuccessfulSalePage({super.key});

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
      height: 20.h,
      showPageTitle: false,
      showDrawer: false,
      image: AppImages.appBarLongImg,
      titleTopPadding: 0.3,
      secondaryColor: true,
    );
  }

  Widget _successImage() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      width: 100.w,
      height: 10.h,
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
      margin: EdgeInsets.only(top: 8.h),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.order_completed,
            style: _titleStyle,
            textAlign: TextAlign.center,
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

        final user = saleState.selectedUser;
        final currency =
            cafeteriaState.selected.school?.currency ??
            CafeteriaConstants.defaultCurrency;

        final isSelfSufficient =
            (user?.selfSufficient ?? false) ||
            (user?.user?.userType ?? "").toUpperCase() == AllowedUsers.TC.name;

        return Container(
          margin: EdgeInsets.only(top: 20.h),
          width: 100.w,
          child: Column(
            children: [
              if (isSelfSufficient) _priceRow(saleState.finalPrice, currency),

              _infoRow(
                AppLocalizations.of(context)!.folio_message,
                SaleUtils.formatFolio(saleState.saleId),
              ),

              _divider(),

              _infoRow(
                AppLocalizations.of(context)!.purchase_date,
                CustomDateUtils.formatDateWithMinutes(DateTime.now()),
              ),

              _divider(),

              _infoRow(
                AppLocalizations.of(context)!.delivery_date,
                SaleUtils.formatDeliveryDate(saleState),
              ),

              if (!isSelfSufficient) ...[
                _divider(),
                _infoRow(
                  AppLocalizations.of(context)!.deliver_to,
                  "${user?.user?.firstName ?? ""} ${user?.user?.lastName ?? ""}",
                ),
                _divider(),
                _infoRow(
                  AppLocalizations.of(context)!.total_items,
                  (saleState.cartProducts ?? []).length.toString(),
                ),
                _divider(),
                _infoRow(
                  AppLocalizations.of(context)!.subtotal,
                  "\$${(saleState.totalPrice ?? 0.0).toStringAsFixed(2)} $currency",
                ),
              ],

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

  Widget _priceRow(String? price, String currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Total", style: _labelStyle.copyWith(fontSize: 22)),
        Text(
          "\$${price ?? "0"} $currency",
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
}
