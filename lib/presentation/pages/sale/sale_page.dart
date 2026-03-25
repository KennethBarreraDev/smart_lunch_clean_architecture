// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_state.dart';
import 'package:smart_lunch/blocs/family/family_bloc.dart';
import 'package:smart_lunch/blocs/family/family_event.dart';
import 'package:smart_lunch/blocs/family/family_state.dart';
import 'package:smart_lunch/blocs/products/products_bloc.dart'
    show ProductsBloc;
import 'package:smart_lunch/blocs/products/products_event.dart';
import 'package:smart_lunch/blocs/products/products_state.dart';
import 'package:smart_lunch/blocs/sales/sales_bloc.dart';
import 'package:smart_lunch/blocs/sales/sales_event.dart';
import 'package:smart_lunch/blocs/sales/sales_state.dart';
import 'package:smart_lunch/blocs/session/session_bloc.dart';
import 'package:smart_lunch/blocs/session/session_state.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/blocs/users/users_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/loader/main_loader.dart';
import 'package:smart_lunch/core/base_widgets/products/products_viewer_list.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/base_widgets/snackbar/awesome_snackbar.dart';
import 'package:smart_lunch/core/constants/user_roles.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/data/repositories/family/family_repository.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/sale/widgets/body/non_selected_presale_date.dart';
import 'package:smart_lunch/presentation/pages/sale/widgets/card/sale_user_card.dart';
import 'package:smart_lunch/presentation/pages/sale/widgets/cart/bottom_cart_component.dart';

class SalePage extends StatelessWidget {
  SalePage({super.key, required this.isPresale});
  bool isPresale;

  @override
  Widget build(BuildContext context) {
    return TransparentScaffold(
      selectedOption: "Inicio",
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, productsState) {
          return productsState is ProductsLoading
              ? MainLoader()
              : Stack(
                  children: [
                    CustomAppBar(
                      height: 25.h,
                      showPageTitle: true,
                      pageTitle: isPresale
                          ? AppLocalizations.of(context)!.presale
                          : AppLocalizations.of(context)!.sale,
                      image: AppImages.appBarShortImg,
                      titleAlignment: Alignment.centerLeft,
                      showDrawer: false,
                    ),

                    Column(
                      children: [
                        BlocBuilder<SessionBloc, SessionState>(
                          builder: (context, sessionState) {
                            if (sessionState is! SessionAuthenticated) {
                              return SizedBox();
                            }
                            return BlocBuilder<CafeteriaBloc, CafeteriaState>(
                              builder: (context, cafeteriaState) {
                                if (cafeteriaState is! CafeteriaSuccess) {
                                  return SizedBox();
                                }
                                return BlocBuilder<UsersBloc, UsersState>(
                                  builder: (context, userState) {
                                    if (userState is! UsersLoaded) {
                                      return SizedBox();
                                    }

                                    return BlocBuilder<FamilyBloc, FamilyState>(
                                      builder: (context, familyState) {
                                        if (familyState is! FamilyLoaded) {
                                          return SizedBox();
                                        }
                                        return BlocBuilder<
                                          SalesBloc,
                                          SaleState
                                        >(
                                          builder: (context, saleState) {
                                            return SaleUserCard(
                                              topMargin: 18.h,
                                              selectedUser:
                                                  sessionState
                                                          .sessionData
                                                          ?.userType ==
                                                      UserRole.tutor
                                                  ? saleState.selectedUser
                                                  : userState.mainUser,
                                              selectedDate: saleState.saleDate,
                                              scheduledHour:
                                                  saleState.scheduledHour,
                                              children: userState.children,
                                              cafeteria:
                                                  cafeteriaState.selected,
                                              cafeteriaSetting: cafeteriaState
                                                  .cafeteriaSettings,
                                              balance:
                                                  familyState.balance -
                                                  userState.totalDebt,
                                              isPresale: isPresale,

                                              sessionData:
                                                  sessionState.sessionData,
                                              onChangeSelectedUser: (user) {
                                                context.read<SalesBloc>().add(
                                                  ChangeSaleUser(user),
                                                );
                                              },
                                              onChangeSelectedDate:
                                                  (date, scheduledHour) {
                                                    context
                                                        .read<SalesBloc>()
                                                        .add(
                                                          ChangeSaleDate(date),
                                                        );
                                                    context
                                                        .read<SalesBloc>()
                                                        .add(
                                                          ChangeScheduledHour(
                                                            scheduledHour,
                                                          ),
                                                        );

                                                    if (isPresale) {
                                                      context
                                                          .read<ProductsBloc>()
                                                          .add(
                                                            LoadProductsEvent(
                                                              cafeteria:
                                                                  cafeteriaState
                                                                      .selected,
                                                              userSelectedDate:
                                                                  date,
                                                              omitFilters:
                                                                  false,
                                                              isPresale:
                                                                  isPresale,
                                                            ),
                                                          );
                                                    }
                                                  },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),

                        BlocBuilder<SessionBloc, SessionState>(
                          builder: (context, sessionState) {
                            if (sessionState is! SessionAuthenticated) {
                              return SizedBox();
                            }
                            return BlocBuilder<UsersBloc, UsersState>(
                              builder: (context, usersState) {
                                if (usersState is! UsersLoaded) {
                                  return SizedBox();
                                }

                                return BlocBuilder<
                                  CafeteriaBloc,
                                  CafeteriaState
                                >(
                                  builder: (context, cafeteriaState) {
                                    if (cafeteriaState is! CafeteriaSuccess) {
                                      return SizedBox();
                                    }

                                    return BlocBuilder<FamilyBloc, FamilyState>(
                                      builder: (context, familyState) {
                                        if (familyState is! FamilyLoaded) {
                                          return SizedBox();
                                        }

                                        return BlocBuilder<
                                          SalesBloc,
                                          SaleState
                                        >(
                                          builder: (context, saleState) {
                                            return (isPresale &&
                                                    saleState.saleDate == null)
                                                ? NonSelectedPresaleDate()
                                                : Expanded(
                                                    child:
                                                        productsState
                                                            is ProductsLoaded
                                                        ? ProductsViewerList(
                                                            categories:
                                                                productsState
                                                                    .categories,
                                                            cart:
                                                                saleState
                                                                    .cart ??
                                                                {},
                                                            products:
                                                                productsState
                                                                    .products,
                                                            addItem: (product) => {
                                                              if ((saleState.totalPrice ??
                                                                          0.0) +
                                                                      (product.price ??
                                                                          0.0) >
                                                                  familyState
                                                                      .balance)
                                                                {
                                                                  showAwesomeSnackBar(
                                                                    context:
                                                                        context,
                                                                    title: AppLocalizations.of(
                                                                      context,
                                                                    )!.please_wait,
                                                                    message: AppLocalizations.of(
                                                                      context,
                                                                    )!.purchase_exceed_balance_message,
                                                                    contentType:
                                                                        ContentType
                                                                            .warning,
                                                                  ),
                                                                }
                                                              else
                                                                {
                                                                  context
                                                                      .read<
                                                                        SalesBloc
                                                                      >()
                                                                      .add(
                                                                        AddProductToSale(
                                                                          product,
                                                                        ),
                                                                      ),
                                                                },
                                                            },
                                                            removeItem: (product) => {
                                                              context
                                                                  .read<
                                                                    SalesBloc
                                                                  >()
                                                                  .add(
                                                                    RemoveProductFromSale(
                                                                      product,
                                                                    ),
                                                                  ),
                                                            },
                                                            loadProducts: () => {
                                                              context.read<ProductsBloc>().add(
                                                                LoadProductsEvent(
                                                                  cafeteria:
                                                                      cafeteriaState
                                                                          .selected,
                                                                  userSelectedDate:
                                                                      saleState
                                                                          .saleDate,
                                                                  omitFilters:
                                                                      false,
                                                                  isPresale:
                                                                      isPresale,
                                                                ),
                                                              ),
                                                            },

                                                            isPresale:
                                                                isPresale,

                                                            bottomSaleCard: BottomCartComponent(
                                                              cart:
                                                                  saleState
                                                                      .cart ??
                                                                  {},
                                                              totalPrice:
                                                                  saleState
                                                                      .totalPrice ??
                                                                  0.0,
                                                              totalProducts:
                                                                  saleState
                                                                      .totalProducts ??
                                                                  0,
                                                              loading:
                                                                  (saleState
                                                                      .validatingSale ??
                                                                  false),
                                                              validateSale: () async {
                                                                final salesBloc =
                                                                    context
                                                                        .read<
                                                                          SalesBloc
                                                                        >();
                                                                final familyBloc =
                                                                    context
                                                                        .read<
                                                                          FamilyBloc
                                                                        >();
                                                                final familyRepository =
                                                                    context
                                                                        .read<
                                                                          FamlilyRepository
                                                                        >();

                                                                salesBloc.add(
                                                                  ValidateSale(
                                                                    true,
                                                                  ),
                                                                );

                                                                try {
                                                                  //Load balance and update it from DB
                                                                  final balance =
                                                                      await familyRepository
                                                                          .loadFamily();

                                                                  //Update balance in bloc
                                                                  familyBloc.add(
                                                                    UpdateFamilyEvent(
                                                                      balance,
                                                                    ),
                                                                  );

                                                                  //User has not sufficient founds
                                                                  if (balance <
                                                                      (salesBloc
                                                                              .state
                                                                              .totalPrice ??
                                                                          0)) {
                                                                    showAwesomeSnackBar(
                                                                      context:
                                                                          context,
                                                                      contentType:
                                                                          ContentType
                                                                              .warning,
                                                                      title: AppLocalizations.of(
                                                                        context,
                                                                      )!.please_wait,
                                                                      message: AppLocalizations.of(
                                                                        context,
                                                                      )!.purchase_exceed_balance_message,
                                                                    );
                                                                  }
                                                                  //User has not selected an hour for sale
                                                                  else if (!isPresale &&
                                                                      (sessionState.sessionData?.userType ==
                                                                              UserRole.teacher ||
                                                                          (saleState.selectedUser?.selfSufficient ??
                                                                              false)) &&
                                                                      saleState
                                                                              .scheduledHour ==
                                                                          null) {
                                                                    showAwesomeSnackBar(
                                                                      context:
                                                                          context,
                                                                      contentType:
                                                                          ContentType
                                                                              .warning,
                                                                      title: AppLocalizations.of(
                                                                        context,
                                                                      )!.please_wait,
                                                                      message: AppLocalizations.of(
                                                                        context,
                                                                      )!.must_select_pickup_date,
                                                                    );
                                                                  } else {
                                                                    //TODO: Load cards depending of the country
                                                                    //TODO: Navigate to summary sale
                                                                  }
                                                                } catch (e) {
                                                                  showAwesomeSnackBar(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        "Unkwown Error",
                                                                    message: e
                                                                        .toString(),
                                                                    contentType:
                                                                        ContentType
                                                                            .failure,
                                                                  );
                                                                }

                                                                salesBloc.add(
                                                                  ValidateSale(
                                                                    false,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                  );
                                          },
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
                  ],
                );
        },
      ),
    );
  }
}
