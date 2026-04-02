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
import 'package:smart_lunch/core/base_widgets/layouts/success_transaction_layout.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';

import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';

import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';
class MembershipSuccessPage extends StatelessWidget {
  const MembershipSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessLayout(
      image: _statusImage(),
      titles: _titles(context),
      content: _content(context),
    );
  }

  Widget _statusImage() {
    return BlocBuilder<MembershipsBloc, MembershipsState>(
      builder: (context, state) {
        final isSuccess = state is MembershipSuccessState &&
            state.transactionStatus == "APPROVED";

        return Container(
          margin: EdgeInsets.only(top: 15.h),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            isSuccess ? AppImages.successRecharge : AppImages.errorRecharge,
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

        return SuccessTitles(
          title: isSuccess
              ? AppLocalizations.of(context)!.payment_completed
              : AppLocalizations.of(context)!.try_again_later,
          subtitle:
              AppLocalizations.of(context)!.purchase_successfully_mesage,
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

        final subtotal = state.membershipTotalPrice ?? 0.0;
        final fee = subtotal * CafeteriaConstants.croemFee / 100;
        final total = subtotal + fee;

        return Container(
          margin: EdgeInsets.only(top: 40.h),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text("Subtotal: $subtotal"),
              Text("Fee: $fee"),
              Text("Total: $total"),
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
}