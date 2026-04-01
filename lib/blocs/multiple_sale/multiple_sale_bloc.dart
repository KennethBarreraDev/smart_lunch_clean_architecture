import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/data/models/multisale_product_model.dart';
import 'package:smart_lunch/data/models/product_model.dart';
import 'package:smart_lunch/data/repositories/sales/sales_repository.dart';

import 'multiple_sale_event.dart';
import 'multiple_sale_state.dart';

class MultipleSaleBloc extends Bloc<MultipleSaleEvent, MultipleSaleState> {
  final SalesRepository repository;

  MultipleSaleBloc(this.repository) : super(InitialMultipleSaleState()) {
    on<SetMultiplesaleAvailableDays>(_setMultiplesaleAvailableDays);
    on<ChangeSelectedUserForMultisale>(_changeSelectedUserForMultisale);
    on<ResetMultiplesaleValue>(_resetMultiplesaleValue);
    on<ChangeSalectedSaleDate>(_changeSalectedSaleDate);
    on<SellProducts>(_sellProducts);
    on<AddProductToMultisale>(_addProductToMultisale);
    on<RemoveProductFromMultisale>(_removeProductFromMultisale);
    on<OnConfirmSaleDateInfo>(_onConfirmSaleDateInfo);
  }

  void _onConfirmSaleDateInfo(
    OnConfirmSaleDateInfo event,
    Emitter<MultipleSaleState> emit,
  ) {
    int saleIndex = state.multisaleProducts.indexWhere(
      (element) => element.saleDate == state.selectedSaleDate?.saleDate,
    );

    if (saleIndex != -1) {
      final List<MultisaleProducts> multisaleProductsCopy = List.from(
        state.multisaleProducts,
      );

      multisaleProductsCopy[saleIndex] = state.selectedSaleDate!.copyWith();

      bool applyDiscount =
          multisaleProductsCopy.where((e) => e.cart.isNotEmpty).length >= 16;

      final newState = state.copyWith(
        multisaleProducts: multisaleProductsCopy,
        disscount: applyDiscount ? CafeteriaConstants.multipleSaleDisccount : 0,
        applyDisscount: applyDiscount,
        canBuy: multisaleProductsCopy.any(
          (element) => element.cartProducts.isNotEmpty,
        ),
      );

      emit(newState);
    }
  }

  void _removeProductFromMultisale(
    RemoveProductFromMultisale event,
    Emitter<MultipleSaleState> emit,
  ) {
    MultisaleProducts? selectedSaleDate = state.selectedSaleDate?.copyWith();

    if (selectedSaleDate != null) {
      ProductModel product = event.product;
      int productID = product.id ?? 0;

      if (selectedSaleDate.cart.containsKey(productID)) {
        selectedSaleDate.totalPrice -= product.price ?? 0.0;
        selectedSaleDate.totalProducts--;

        selectedSaleDate.cart.update(productID, (value) => value - 1);

        selectedSaleDate.cart.removeWhere((k, v) => v <= 0);

        if (!selectedSaleDate.cart.containsKey(productID)) {
          selectedSaleDate.cartProducts.removeWhere((e) => e.id == productID);
        }
      }

      if (selectedSaleDate.cartProducts.isEmpty) {
        selectedSaleDate = selectedSaleDate.copyWith(selected: false);
      }

      final updatedList = state.multisaleProducts.map((e) {
        if (e.saleDate == selectedSaleDate!.saleDate) {
          return selectedSaleDate;
        }
        return e;
      }).toList();

      final total = state.totalPrice - (product.price ?? 0.0);

      emit(
        state.copyWith(
          selectedSaleDate: selectedSaleDate,
          totalPrice: total,
          canBuy: updatedList.any((e) => e.cartProducts.isNotEmpty),
        ),
      );
    }
  }

  void _addProductToMultisale(
    AddProductToMultisale event,
    Emitter<MultipleSaleState> emit,
  ) {
    MultisaleProducts? selectedSaleDate = state.selectedSaleDate?.copyWith();

    if (selectedSaleDate != null) {
      final product = event.product;
      int productID = product.id ?? 0;

      selectedSaleDate.totalPrice += product.price ?? 0.0;

      if (selectedSaleDate.cart.containsKey(productID)) {
        selectedSaleDate.cart.update(productID, (value) => value + 1);
      } else {
        selectedSaleDate.cart.addAll({productID: 1});
        selectedSaleDate.cartProducts.add(product);
      }

      selectedSaleDate.totalProducts += 1;

      if (!selectedSaleDate.selected) {
        selectedSaleDate = selectedSaleDate.copyWith(selected: true);
      }
      
      final total = state.totalPrice + (product.price ?? 0.0);

      emit(
        state.copyWith(
          selectedSaleDate: selectedSaleDate,
          totalPrice: total,
          canBuy: true,
        ),
      );
    }
  }

  void _changeSelectedUserForMultisale(
    ChangeSelectedUserForMultisale event,
    Emitter<MultipleSaleState> emit,
  ) {
    emit(state.copyWith(selectedUser: event.selectedUser));
  }

  void _resetMultiplesaleValue(
    ResetMultiplesaleValue event,
    Emitter<MultipleSaleState> emit,
  ) {
    emit(InitialMultipleSaleState());
  }

  void _changeSalectedSaleDate(
    ChangeSalectedSaleDate event,
    Emitter<MultipleSaleState> emit,
  ) {
    emit(
      state.copyWith(
        selectedSaleDate: MultisaleProducts(
          saleDate: event.saleDate ?? DateTime.now(),
          cart: event.cart ?? {},
          cartProducts: event.cartProducts ?? [],
          totalPrice: event.totalPrice ?? 0,
          totalProducts: event.totalProducts ?? 0,
          selected: event.selected ?? false,
          comment: event.comment ?? "",
        ),
      ),
    );
  }

  void _setMultiplesaleAvailableDays(
    SetMultiplesaleAvailableDays event,
    Emitter<MultipleSaleState> emit,
  ) {
    DateTime now = DateTime.now();
    int startDay = 0;

    if (now.weekday == DateTime.saturday) {
      startDay = 2;
    } else if (now.weekday == DateTime.sunday && now.hour < 12) {
      startDay = 1;
    } else {
      startDay = now.hour > 12 ? 2 : 1;
    }

    now = now.add(Duration(days: startDay));

    final List<MultisaleProducts> multisaleProducts = [];
    int i = 0;

    while (multisaleProducts.length < 20) {
      DateTime saleDay = now.add(Duration(days: i));

      if (saleDay.weekday != DateTime.saturday &&
          saleDay.weekday != DateTime.sunday) {
        multisaleProducts.add(
          MultisaleProducts(
            saleDate: saleDay,
            cart: {},
            cartProducts: [],
            totalPrice: 0,
            totalProducts: 0,
            selected: false,
          ),
        );
      }

      i++;
    }

    emit(state.copyWith(multisaleProducts: multisaleProducts));
  }

  Future<void> _sellProducts(
    SellProducts event,
    Emitter<MultipleSaleState> emit,
  ) async {
    emit(state.copyWith(proccessingSale: true));

    final success = await repository.placeMultisale(
      multisaleProducts: state.multisaleProducts,
      userBuyer: state.selectedUser?.id.toString(),
    );

    emit(
      success
          ? MultipleSaleSuccessState(
              selectedUser: state.selectedUser,
              multisaleProducts: state.multisaleProducts,
              selectedSaleDate: state.selectedSaleDate,
              totalPrice: state.totalPrice,
              proccessingSale: false,
              comments: state.comments,
              applyDisscount: state.applyDisscount,
              disscount: state.disscount,
              loading: false,
              canBuy: state.canBuy,
            )
          : MultipleSaleErrorState(
              selectedUser: state.selectedUser,
              multisaleProducts: state.multisaleProducts,
              selectedSaleDate: state.selectedSaleDate,
              totalPrice: state.totalPrice,
              proccessingSale: false,
              comments: state.comments,
              applyDisscount: state.applyDisscount,
              disscount: state.disscount,
              loading: false,
              canBuy: state.canBuy,
            ),
    );
  }
}
