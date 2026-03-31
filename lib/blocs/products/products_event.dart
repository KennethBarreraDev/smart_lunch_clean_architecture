import 'package:smart_lunch/data/models/cafeteria_model.dart';

abstract class ProductsEvent {

}

class LoadProductsEvent extends ProductsEvent {
  Cafeteria cafeteria;
  DateTime? userSelectedDate;
  bool omitFilters;
  bool isPresale;
  LoadProductsEvent({
    required this.cafeteria,
    this.userSelectedDate,
    this.omitFilters = true,
    this.isPresale = false,
  });
}

class ResetProductsEvent extends ProductsEvent {}
