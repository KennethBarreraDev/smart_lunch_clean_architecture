import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:smart_lunch/blocs/products/products_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/go_back_button.dart'
    show GoBackButton;
import 'package:smart_lunch/core/base_widgets/loader/main_loader.dart';
import 'package:smart_lunch/core/base_widgets/products/products_viewer_list.dart';
import 'package:smart_lunch/core/base_widgets/snackbar/awesome_snackbar.dart';
import 'package:smart_lunch/core/base_widgets/users/user_balance_card.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class MultisaleProducts extends StatelessWidget {
  const MultisaleProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) {},
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 80),
              height: MediaQuery.of(context).size.height * 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [AppColors.coral, AppColors.orange],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: GoBackButton(
                      title: AppLocalizations.of(context)!.multisale,
                    ),
                  ),
                  const SizedBox(height: 10),

                  BlocBuilder<FamilyBloc, FamilyState>(
                    builder: (context, familyState) {
                      if (familyState is! FamilyLoaded) {
                        return const SizedBox.shrink();
                      }
                      return BlocBuilder<MultipleSaleBloc, MultipleSaleState>(
                        builder: (context, multisaleState) {
                          return UserBalanceCard(
                            user: multisaleState.selectedUser,
                            familyBalance: familyState.balance.toString(),
                            date:
                                multisaleState.selectedSaleDate?.saleDate ??
                                DateTime.now(),
                          );
                        },
                      );
                    },
                  ),

                  Divider(color: AppColors.white.withValues(alpha: 0.3)),

                  BlocBuilder<MultipleSaleBloc, MultipleSaleState>(
                    builder: (context, multipleSaleState) {
                      return BlocBuilder<CafeteriaBloc, CafeteriaState>(
                        builder: (context, cafeteriaState) {
                          if (cafeteriaState is! CafeteriaSuccess) {
                            return const SizedBox.shrink();
                          }

                          return BlocBuilder<FamilyBloc, FamilyState>(
                            builder: (context, familyState) {
                              if (familyState is! FamilyLoaded) {
                                return const SizedBox.shrink();
                              }

                              return BlocBuilder<ProductsBloc, ProductsState>(
                                builder: (context, productsState) {
                                  if (productsState is! ProductsLoaded) {
                                    return MainLoader();
                                  }

                                  return ProductsViewerList(
                                    categories: productsState.categories,
                                    cart:
                                        multipleSaleState
                                            .selectedSaleDate
                                            ?.cart ??
                                        {},
                                    products: productsState.products,

                                    addItem: (product) {
                                      if ((multipleSaleState.totalPrice) +
                                              (product.price ?? 0.0) >
                                          familyState.balance) {
                                        showAwesomeSnackBar(
                                          context: context,
                                          title: AppLocalizations.of(
                                            context,
                                          )!.please_wait,
                                          message: AppLocalizations.of(
                                            context,
                                          )!.purchase_exceed_balance_message,
                                          contentType: ContentType.warning,
                                        );
                                      } else {
                                        context.read<MultipleSaleBloc>().add(
                                          AddProductToMultisale(product),
                                        );
                                      }
                                    },

                                    removeItem: (product) {
                                      context.read<MultipleSaleBloc>().add(
                                        RemoveProductFromMultisale(product),
                                      );
                                    },

                                    loadProducts: () {
                                      context.read<ProductsBloc>().add(
                                        LoadProductsEvent(
                                          cafeteria: cafeteriaState.selected,
                                          userSelectedDate:
                                              multipleSaleState
                                                  .selectedSaleDate
                                                  ?.saleDate ??
                                              DateTime.now(),
                                          omitFilters: false,
                                          isPresale: true,
                                        ),
                                      );
                                    },

                                    isPresale: true,

                                    bottomSaleCard: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 80,
                                        color: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.subtotal,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: "Comfortaa",
                                                    color: Colors.black26,
                                                  ),
                                                ),
                                                Text(
                                                  "\$${(multipleSaleState.selectedSaleDate?.totalPrice ?? 0.0).toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                    color: AppColors.darkBlue,
                                                    fontSize: 20,
                                                    fontFamily: "Outfit",
                                                  ),
                                                ),
                                              ],
                                            ),

                                            TextButton(
                                              onPressed: () {},
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.edit_note,
                                                    color: AppColors.lightBlue,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.comments_message,
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.lightBlue,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<MultipleSaleBloc>()
                                                    .add(
                                                      OnConfirmSaleDateInfo(),
                                                    );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: AppColors.tuitionGreen
                                                      .withValues(alpha: 0.2),
                                                ),
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.confirm_button,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        AppColors.tuitionGreen,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
