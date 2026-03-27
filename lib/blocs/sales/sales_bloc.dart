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
    on<SaveComments>(_saveComments);
    on<PayWithBalance>(_payWithBalance);
    on<ResetSaleEvent>(_resetSale);
    on<IsLoadingSales>(_isLoadingSales);
    on<SellProducts>(_sellProducts);
  }
  Future<void> _sellProducts(
    SellProducts event,
    Emitter<SaleState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final success = await repository.sellProducts(
      userBuyer: event.userBuyer,
      saleDate: event.saleDate,
      cart: event.cart,
      comments: event.comments,
      isPresale: event.isPresale,
      isAutosuficientStudent: event.isAutosuficientStudent,
      payWithBalance: event.payWithBalance,
      cardId: event.cardId,
      deviceSessionId: event.deviceSessionId,
    );

    emit(state.copyWith(loading: false));
    if (success.isNotEmpty) {
      emit(
        SaleSuccessState(
          saleId: success["saleId"],
          finalPrice: success["finalPrice"],
          selectedUser: state.selectedUser,
          saleDate: state.saleDate,
          scheduledHour: state.scheduledHour,
          cart: state.cart,
          cartProducts: state.cartProducts,
          totalPrice: state.totalPrice,
          totalProducts: state.totalProducts,
          validatingSale: state.validatingSale,
          comments: state.comments,
          payWithBalance: state.payWithBalance,
          loading: state.loading,
          isPresale: state.isPresale,
        ),
      );
    } else {
      emit(
        SaleErrorState(
          selectedUser: state.selectedUser,
          saleDate: state.saleDate,
          scheduledHour: state.scheduledHour,
          cart: state.cart,
          cartProducts: state.cartProducts,
          totalPrice: state.totalPrice,
          totalProducts: state.totalProducts,
          validatingSale: state.validatingSale,
          comments: state.comments,
          payWithBalance: state.payWithBalance,
          loading: state.loading,
          isPresale: state.isPresale,
        ),
      );
    }
  }

  void _isLoadingSales(IsLoadingSales event, Emitter<SaleState> emit) {
    emit(state.copyWith(loading: event.isLoading));
  }

  void _payWithBalance(PayWithBalance event, Emitter<SaleState> emit) {
    emit(state.copyWith(payWithBalance: event.payWithBalance));
  }

  void _saveComments(SaveComments event, Emitter<SaleState> emit) {
    emit(state.copyWith(comments: event.comments));
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
