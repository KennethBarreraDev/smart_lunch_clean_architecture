import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/data/models/product_model.dart';
import 'package:smart_lunch/data/repositories/sales/sales_repository.dart';

import 'sales_event.dart';
import 'sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SaleState> {
  final SalesRepository repository;

  SalesBloc(this.repository) : super(InitialSalesState()) {
    on<SaleInit>(_changeSaleType);
    on<ChangeSaleUser>(_onChangeSaleUser);
    on<ChangeSaleDate>(_onChangeSaleDate);
    on<ChangeScheduledHour>(_onChangeScheduledHour);
    on<ResetSaleEvent>(_resetSale);
    on<AddProductToSale>(_addProductToSale);
    on<RemoveProductFromSale>(_removeProductFromSale);
    on<ValidateSale>(_validateSale);
  }

  void _validateSale(ValidateSale event, Emitter<SaleState> emit) {
    emit(state.copyWith(validatingSale: event.validatingSale));
  }

  void _addProductToSale(AddProductToSale event, Emitter<SaleState> emit) {
    final product = event.product;

    final newCart = Map<int, int>.from(state.cart ?? {});
    final newCartProducts = List<ProductModel>.from(state.cartProducts ?? []);

    if (newCart.containsKey(product.id)) {
      newCart[product.id ?? 0] = newCart[product.id]! + 1;
    } else {
      newCart[product.id!] = 1;
      newCartProducts.add(product);
    }

    final newTotalPrice = (state.totalPrice ?? 0) + (product.price ?? 0);
    final newTotalProducts = (state.totalProducts ?? 0) + 1;

    print("New cart $newCart");

    emit(
      state.copyWith(
        cart: newCart,
        cartProducts: newCartProducts,
        totalPrice: newTotalPrice,
        totalProducts: newTotalProducts,
      ),
    );
  }

  void _removeProductFromSale(
    RemoveProductFromSale event,
    Emitter<SaleState> emit,
  ) {
    final product = event.product;

    final newCart = Map<int, int>.from(state.cart ?? {});
    final newCartProducts = List<ProductModel>.from(state.cartProducts ?? []);

    if (!newCart.containsKey(product.id)) return;

    newCart[product.id ?? 0] = newCart[product.id]! - 1;

    if (newCart[product.id]! <= 0) {
      newCart.remove(product.id);
      newCartProducts.removeWhere((p) => p.id == product.id);
    }

    final newTotalPrice = (state.totalPrice ?? 0) - (product.price ?? 0);
    final newTotalProducts = (state.totalProducts ?? 0) - 1;

    emit(
      state.copyWith(
        cart: newCart,
        cartProducts: newCartProducts,
        totalPrice: newTotalPrice < 0 ? 0 : newTotalPrice,
        totalProducts: newTotalProducts < 0 ? 0 : newTotalProducts,
      ),
    );
  }

  void _resetSale(ResetSaleEvent event, Emitter<SaleState> emit) {
    emit(InitialSalesState());
  }

  void _changeSaleType(SaleInit event, Emitter<SaleState> emit) {
    emit(state.copyWith(isPresale: event.isPresale));
  }

  void _onChangeSaleUser(ChangeSaleUser event, Emitter<SaleState> emit) {
    emit(state.copyWith(selectedUser: event.user));
  }

  void _onChangeScheduledHour(
    ChangeScheduledHour event,
    Emitter<SaleState> emit,
  ) {
    emit(state.copyWith(scheduledHour: event.scheduledHour));
  }

  void _onChangeSaleDate(ChangeSaleDate event, Emitter<SaleState> emit) {
    emit(state.copyWith(saleDate: event.date));
  }
}
