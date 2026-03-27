import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/product_model.dart';

class SaleState {
  final CafeteriaUser? selectedUser;
  final DateTime? saleDate;
  final bool isPresale;
  final String? scheduledHour;
  final Map<int, int>? cart;
  final List<ProductModel>? cartProducts;
  final double? totalPrice;
  final int? totalProducts;
  final bool? validatingSale;
  final String? comments;
  final bool? payWithBalance;
  final bool? loading;

  SaleState({
    this.selectedUser,
    this.saleDate,
    this.scheduledHour,
    this.cartProducts,
    this.totalPrice,
    this.totalProducts,
    this.isPresale = false,
    this.validatingSale = false,
    this.cart,
    this.comments,
    this.payWithBalance,
    this.loading,
  });

  SaleState copyWith({
    CafeteriaUser? selectedUser,
    DateTime? saleDate,
    bool? isPresale,
    String? scheduledHour,
    Map<int, int>? cart,
    List<ProductModel>? cartProducts,
    double? totalPrice,
    int? totalProducts,
    bool? validatingSale,
    String? comments,
    bool? payWithBalance,
    bool? loading,
  }) {
    return SaleState(
      selectedUser: selectedUser ?? this.selectedUser,
      saleDate: saleDate ?? this.saleDate,
      isPresale: isPresale ?? this.isPresale,
      scheduledHour: scheduledHour ?? this.scheduledHour,
      cart: cart ?? this.cart,
      cartProducts: cartProducts ?? this.cartProducts,
      totalPrice: totalPrice ?? this.totalPrice,
      totalProducts: totalProducts ?? this.totalProducts,
      validatingSale: validatingSale ?? this.validatingSale,
      comments: comments ?? this.comments,
      payWithBalance: payWithBalance ?? this.payWithBalance,
      loading: loading ?? this.loading,
    );
  }
}

class SaleSuccessState extends SaleState {
  final String? saleId;
  final String? finalPrice;

  SaleSuccessState({
    CafeteriaUser? selectedUser,
    DateTime? saleDate,
    bool? isPresale,
    String? scheduledHour,
    Map<int, int>? cart,
    List<ProductModel>? cartProducts,
    double? totalPrice,
    int? totalProducts,
    bool? validatingSale,
    String? comments,
    bool? payWithBalance,
    bool? loading,
    this.saleId,
    this.finalPrice,
  }) : super(
         selectedUser: selectedUser,
         saleDate: saleDate,
         isPresale: isPresale ?? false,
         scheduledHour: scheduledHour,
         cart: cart,
         cartProducts: cartProducts,
         totalPrice: totalPrice,
         totalProducts: totalProducts,
         validatingSale: validatingSale ?? false,
         comments: comments,
         payWithBalance: payWithBalance,
         loading: loading,
       );
}

class SaleErrorState extends SaleState {
  SaleErrorState({
    CafeteriaUser? selectedUser,
    DateTime? saleDate,
    bool? isPresale,
    String? scheduledHour,
    Map<int, int>? cart,
    List<ProductModel>? cartProducts,
    double? totalPrice,
    int? totalProducts,
    bool? validatingSale,
    String? comments,
    bool? payWithBalance,
    bool? loading,
  }) : super(
         selectedUser: selectedUser,
         saleDate: saleDate,
         isPresale: isPresale ?? false,
         scheduledHour: scheduledHour,
         cart: cart,
         cartProducts: cartProducts,
         totalPrice: totalPrice,
         totalProducts: totalProducts,
         validatingSale: validatingSale ?? false,
         comments: comments,
         payWithBalance: payWithBalance,
         loading: loading,
       );
}

class InitialSalesState extends SaleState {
  InitialSalesState()
    : super(
        selectedUser: null,
        saleDate: null,
        scheduledHour: null,
        isPresale: false,
        cart: {},
        cartProducts: [],
        totalPrice: 0.0,
        totalProducts: 0,
        validatingSale: false,
        comments: "",
        payWithBalance: false,
      );
}
