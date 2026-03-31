import 'package:flutter_bloc/flutter_bloc.dart';
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

        selectedSaleDate.cart.update(
          productID,
          (value) => (selectedSaleDate?.cart[productID] ?? 0) - 1,
        );
        selectedSaleDate.cart.removeWhere((key, value) => value <= 0);
        if (!selectedSaleDate.cart.containsKey(productID)) {
          selectedSaleDate.cartProducts.removeWhere(
            (element) => element.id == productID,
          );
        }
      }

      final double currentTotalPrice =
          state.totalPrice - (product.price ?? 0.0);

      state.copyWith(
        selectedSaleDate: selectedSaleDate,
        totalPrice: currentTotalPrice,
      );

      if (selectedSaleDate.cartProducts.isEmpty) {
        selectedSaleDate = selectedSaleDate.copyWith(selected: false);
      }
    }
  }

  void _addProductToMultisale(
    AddProductToMultisale event,
    Emitter<MultipleSaleState> emit,
  ) {
    MultisaleProducts? selectedSaleDate = state.selectedSaleDate?.copyWith();
    if (selectedSaleDate != null) {
      final ProductModel product = event.product;
      int productID = event.product.id ?? 0;

      selectedSaleDate.totalPrice += product.price ?? 0.0;

      if (selectedSaleDate.cart.containsKey(productID)) {
        selectedSaleDate.cart.update(
          productID,
          (value) => (selectedSaleDate?.cart[productID] ?? 0) + 1,
        );
      } else {
        selectedSaleDate.cart.addAll({productID: 1});
        selectedSaleDate.cartProducts.add(product);
      }

      selectedSaleDate.totalProducts += 1;

      final double currentTotalPrice =
          state.totalPrice + (product.price ?? 0.0);

      state.copyWith(
        selectedSaleDate: selectedSaleDate,
        totalPrice: currentTotalPrice,
      );

      if (!selectedSaleDate.selected) {
        selectedSaleDate = selectedSaleDate.copyWith(selected: true);
        state.copyWith(canBuy: true);
      }
    }
  }

  void _changeSelectedUserForMultisale(
    ChangeSelectedUserForMultisale event,
    Emitter<MultipleSaleState> emit,
  ) {
    emit(state.copyWith(selectedUser: state.selectedUser));
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
      now = now.add(Duration(days: startDay));
    } else if (now.weekday == DateTime.sunday && now.hour < 12) {
      startDay = 1;
      now = now.add(Duration(days: startDay));
    } else {
      startDay = now.hour > 12 ? 2 : 1;
      now = now.add(Duration(days: startDay));

      if (now.weekday == DateTime.saturday) {
        startDay = 2;

        now = now.add(Duration(days: startDay));
      } else if (now.weekday == DateTime.sunday) {
        startDay = 1;

        now = now.add(Duration(days: startDay));
      }
    }

    int i = 0;
    final List<MultisaleProducts> multisaleProducts = [];

    while ((state.multisaleProducts.length) < 20) {
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

    final bool success = await repository.placeMultisale(
      multisaleProducts: state.multisaleProducts,
      userBuyer: state.selectedUser?.id.toString(),
    );

    if (success) {
      emit(
        MultipleSaleSuccessState(
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
    } else {
      emit(
        MultipleSaleErrorState(
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
}
