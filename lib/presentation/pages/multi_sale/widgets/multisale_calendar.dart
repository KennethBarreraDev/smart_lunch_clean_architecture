import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/family/family_bloc.dart';
import 'package:smart_lunch/blocs/family/family_state.dart';
import 'package:smart_lunch/blocs/multiple_sale/multiple_sale_bloc.dart';
import 'package:smart_lunch/blocs/multiple_sale/multiple_sale_event.dart';
import 'package:smart_lunch/blocs/multiple_sale/multiple_sale_state.dart';
import 'package:smart_lunch/blocs/products/products_bloc.dart';
import 'package:smart_lunch/blocs/products/products_event.dart';
import 'package:smart_lunch/core/base_widgets/appbar/go_back_button.dart';
import 'package:smart_lunch/core/base_widgets/users/user_balance_card.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/core/utils/date_utils.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/multi_sale/widgets/multisale_calendar_component.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class MultisaleCalendar extends StatelessWidget {
  const MultisaleCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 100.h),
            width: 100.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColors.coral, AppColors.orange],
              ),
            ),
            child: BlocBuilder<CafeteriaBloc, CafeteriaState>(
              builder: (context, cafeteriaState) {
                if (cafeteriaState is! CafeteriaSuccess) {
                  return SizedBox.shrink();
                }

                return BlocBuilder<FamilyBloc, FamilyState>(
                  builder: (context, familyState) {
                    if (familyState is! FamilyLoaded) {
                      return SizedBox.shrink();
                    }

                    return BlocBuilder<MultipleSaleBloc, MultipleSaleState>(
                      builder: (context, multisaleState) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                child: GoBackButton(
                                  title: AppLocalizations.of(
                                    context,
                                  )!.multisale,
                                ),
                              ),

                              const SizedBox(height: 10),

                              UserBalanceCard(
                                user: multisaleState.selectedUser,
                                familyBalance:
                                    (familyState.balance -
                                            multisaleState.totalPrice -
                                            multisaleState.disscount)
                                        .toString(),
                              ),
                              const SizedBox(height: 10),
                              Divider(
                                color: AppColors.white.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 10),
                              ...(multisaleState.multisaleProducts)
                                  .map(
                                    (element) => Align(
                                      alignment: Alignment.center,
                                      child: MultisaleCalendarComponent(
                                        salePrice: element.totalPrice,
                                        selected: element.selected,
                                        date:
                                            CustomDateUtils.formatDateForPresale(
                                              element.saleDate,
                                            ),
                                        onTap: () {
                                          context.read<MultipleSaleBloc>().add(
                                            ChangeSalectedSaleDate(
                                              saleDate: element.saleDate,
                                              cart: element.cart,
                                              cartProducts:
                                                  element.cartProducts,
                                              totalPrice: element.totalPrice,
                                              totalProducts:
                                                  element.totalProducts,
                                              selected: element.selected,
                                              comment: element.comment,
                                            ),
                                          );

                                          context.read<ProductsBloc>().add(
                                            LoadProductsEvent(
                                              cafeteria:
                                                  cafeteriaState.selected,
                                              userSelectedDate:
                                                  element.saleDate,
                                              omitFilters: false,
                                              isPresale: true,
                                            ),
                                          );

                                          context.pushNamed(
                                            AppRoutes.getCleanRouteName(
                                              AppRoutes.multisaleProducts,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          BlocBuilder<MultipleSaleBloc, MultipleSaleState>(
            builder: (context, multipleSaleState) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            if (multipleSaleState.applyDisscount)
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 35,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.tuitionGreen.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.disccount_message,
                                            style: TextStyle(
                                              color: AppColors.tuitionGreen,
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            "\$${CafeteriaConstants.multipleSaleDisccount}",
                                            style: TextStyle(
                                              color: AppColors.tuitionGreen,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 5),
                            Text(
                              AppLocalizations.of(context)!.subtotal,
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: "Comfortaa",
                                color: Colors.black26,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    style: TextStyle(
                                      color: AppColors.darkBlue,
                                      fontSize: 20.0,
                                      fontFamily: "Outfit",
                                    ),
                                    text: "\$${multipleSaleState.totalPrice}",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<MultipleSaleBloc>().add(SellProducts());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: multipleSaleState.canBuy
                                ? AppColors.tuitionGreen.withValues(alpha: 0.2)
                                : AppColors.darkBlue.withValues(alpha: 0.2),
                          ),
                          child: multipleSaleState.proccessingSale
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.tuitionGreen,
                                  ),
                                )
                              : Text(
                                  multipleSaleState.canBuy
                                      ? AppLocalizations.of(context)!.buy_now
                                      : AppLocalizations.of(
                                          context,
                                        )!.make_one_order,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: multipleSaleState.canBuy
                                        ? AppColors.tuitionGreen
                                        : AppColors.darkBlue,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
