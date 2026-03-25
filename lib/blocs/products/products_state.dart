import 'package:smart_lunch/data/models/product_category_model.dart';
import 'package:smart_lunch/data/models/product_model.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;
  final List<ProductCategory> categories;

  ProductsLoaded({required this.products, required this.categories});
}

class ResetProducts extends ProductsState {
  final List<ProductModel> products;
  final List<ProductCategory> categories;

  ResetProducts(this.categories, this.products);
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError(this.message);
}
