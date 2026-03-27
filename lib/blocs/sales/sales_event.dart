import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/product_model.dart';

abstract class SalesEvent {}

class SaleInit extends SalesEvent {
  final bool isPresale;

  SaleInit({required this.isPresale});
}

class ChangeSaleUser extends SalesEvent {
  final CafeteriaUser user;

  ChangeSaleUser(this.user);
}

class ChangeSaleDate extends SalesEvent {
  final DateTime? date;

  ChangeSaleDate(this.date);
}

class ChangeScheduledHour extends SalesEvent {
  final String? scheduledHour;

  ChangeScheduledHour(this.scheduledHour);
}

class AddProductToSale extends SalesEvent {
  final ProductModel product;

  AddProductToSale(this.product);
}

class RemoveProductFromSale extends SalesEvent {
  final ProductModel product;

  RemoveProductFromSale(this.product);
}

class ValidateSale extends SalesEvent {
  final bool validatingSale;

  ValidateSale(this.validatingSale);
}

class SaveComments extends SalesEvent {
  final String comments;

  SaveComments(this.comments);
}

class PayWithBalance extends SalesEvent {
  final bool payWithBalance;

  PayWithBalance(this.payWithBalance);
}

class IsLoadingSales extends SalesEvent {
  final bool isLoading;

  IsLoadingSales(this.isLoading);
}

class SellProducts extends SalesEvent {
  final String? userBuyer;
  final DateTime? saleDate;
  final Map<int, int>? cart;
  final String? comments;
  final bool isPresale;
  final bool isAutosuficientStudent;
  final bool payWithBalance;
  final String? cardId;
  final String? deviceSessionId;

  SellProducts({
    this.userBuyer,
    this.saleDate,
    this.cart,
    this.comments,
    this.isPresale = false,
    this.isAutosuficientStudent = false,
    this.payWithBalance = false,
    this.cardId,
    this.deviceSessionId,
  });
}

class ResetSaleEvent extends SalesEvent {
  ResetSaleEvent();
}
