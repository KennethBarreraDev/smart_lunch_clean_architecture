import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/product_model.dart';

abstract class MultipleSaleEvent {}

class ChangeSelectedUserForMultisale extends MultipleSaleEvent {
  final CafeteriaUser? selectedUser;
  ChangeSelectedUserForMultisale(this.selectedUser);
}

class SetMultiplesaleAvailableDays extends MultipleSaleEvent {
  SetMultiplesaleAvailableDays();
}

class ChangeSalectedSaleDate extends MultipleSaleEvent {
  final DateTime? saleDate;
  final Map<int, int>? cart;
  final List<ProductModel>? cartProducts;
  final double? totalPrice;
  final int? totalProducts;
  final bool? selected;
  final String? comment;

  ChangeSalectedSaleDate({
    this.saleDate,
    this.cart,
    this.cartProducts,
    this.totalPrice,
    this.totalProducts,
    this.selected,
    this.comment,
  });
}

class SellProducts extends MultipleSaleEvent {
  SellProducts();
}

class AddProductToMultisale extends MultipleSaleEvent {
  final ProductModel product;
  AddProductToMultisale(this.product);
}

class RemoveProductFromMultisale extends MultipleSaleEvent {
  final ProductModel product;
  RemoveProductFromMultisale(this.product);
}

class ResetMultiplesaleValue extends MultipleSaleEvent {
  ResetMultiplesaleValue();
}

class OnConfirmSaleDateInfo extends MultipleSaleEvent{
  OnConfirmSaleDateInfo();
}
