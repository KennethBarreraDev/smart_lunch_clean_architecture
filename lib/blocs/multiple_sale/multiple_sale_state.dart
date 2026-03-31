import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/multisale_product_model.dart';
import 'package:smart_lunch/data/models/product_model.dart';

class MultipleSaleState {
  final CafeteriaUser? selectedUser;
  final MultisaleProducts? selectedSaleDate;
  final List<MultisaleProducts> multisaleProducts;
  final double totalPrice;
  final bool proccessingSale;
  final String comments;
  final bool applyDisscount;
  final double disscount;
  final bool loading;
  final bool canBuy;

  MultipleSaleState({
    this.selectedUser,
    this.multisaleProducts = const [],
    this.selectedSaleDate,
    this.totalPrice = 0.0,
    this.proccessingSale = false,
    this.comments = "",
    this.applyDisscount = false,
    this.disscount = 0.0,
    this.loading = false,
    this.canBuy = true,
  });

  MultipleSaleState copyWith({
    CafeteriaUser? selectedUser,
    List<MultisaleProducts>? multisaleProducts,
    MultisaleProducts? selectedSaleDate,
    Map<int, int>? cart,
    List<ProductModel>? cartProducts,
    double? totalPrice,
    bool? proccessingSale,
    String? comments,
    bool? applyDisscount,
    double? disscount,
    bool? loading,
    bool? canBuy,
  }) {
    return MultipleSaleState(
      selectedUser: selectedUser ?? this.selectedUser,
      multisaleProducts: multisaleProducts ?? this.multisaleProducts,
      selectedSaleDate: selectedSaleDate ?? this.selectedSaleDate,
      totalPrice: totalPrice ?? this.totalPrice,
      proccessingSale: proccessingSale ?? this.proccessingSale,
      comments: comments ?? this.comments,
      applyDisscount: applyDisscount ?? this.applyDisscount,
      disscount: disscount ?? this.disscount,
      loading: loading ?? this.loading,
      canBuy: canBuy ?? this.canBuy,
    );
  }
}

class MultipleSaleSuccessState extends MultipleSaleState {
  final String? saleId;
  final String? finalPrice;

  MultipleSaleSuccessState({
    CafeteriaUser? selectedUser,
    List<MultisaleProducts>? multisaleProducts,
    MultisaleProducts? selectedSaleDate,
    Map<int, int>? cart,
    List<ProductModel>? cartProducts,
    double? totalPrice,
    bool? proccessingSale,
    String? comments,
    bool? applyDisscount,
    double? disscount,
    bool? loading,
    bool? canBuy,
    this.saleId,
    this.finalPrice,
  }) : super(
         selectedUser: selectedUser,
         multisaleProducts: multisaleProducts ?? const [],
         selectedSaleDate: selectedSaleDate,
         totalPrice: totalPrice ?? 0.0,
         proccessingSale: proccessingSale ?? false,
         comments: comments ?? "",
         applyDisscount: applyDisscount ?? false,
         disscount: disscount ?? 0.0,
         loading: loading ?? false,
         canBuy: canBuy ?? true,
       );
}

class MultipleSaleErrorState extends MultipleSaleState {
  MultipleSaleErrorState({
    CafeteriaUser? selectedUser,
    List<MultisaleProducts>? multisaleProducts,
    MultisaleProducts? selectedSaleDate,
    Map<int, int>? cart,
    List<ProductModel>? cartProducts,
    double? totalPrice,
    bool? proccessingSale,
    String? comments,
    bool? applyDisscount,
    double? disscount,
    bool? loading,
    bool? canBuy,
  }) : super(
         selectedUser: selectedUser,
         multisaleProducts: multisaleProducts ?? const [],
         selectedSaleDate: selectedSaleDate,
         totalPrice: totalPrice ?? 0.0,
         proccessingSale: proccessingSale ?? false,
         comments: comments ?? "",
         applyDisscount: applyDisscount ?? false,
         disscount: disscount ?? 0.0,
         loading: loading ?? false,
         canBuy: canBuy ?? true,
       );
}

class InitialMultipleSaleState extends MultipleSaleState {
  InitialMultipleSaleState()
    : super(
        selectedUser: null,
        multisaleProducts: const [],
        selectedSaleDate: null,
        totalPrice: 0.0,
        proccessingSale: false,
        comments: "",
        applyDisscount: false,
        disscount: 0.0,
        loading: false,
        canBuy: true,
      );
}
