import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/product_category_model.dart';
import 'package:smart_lunch/data/models/product_model.dart';
import 'package:smart_lunch/data/models/user_model.dart';
import 'package:smart_lunch/data/repositories/product/product_repository.dart';
import 'package:smart_lunch/data/repositories/users/users_repository.dart';

import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository repository;

  ProductsBloc(this.repository) : super(ProductsInitial()) {
    on<LoadProductsEvent>(_loadProducts);
    on<ResetProductsEvent>(_resetProducts);
  }

  Future<void> _loadProducts(
    LoadProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());

    try {
      final results = await Future.wait([
        repository.loadCategories(),
        repository.loadProducts(
          event.cafeteria,
          userSelectedDate: event.userSelectedDate,
          omitFilters: event.omitFilters,
          isPresale: event.isPresale,
        ),
      ]);

      final List<ProductCategory> categories =
          results[0] as List<ProductCategory>;
      final List<ProductModel> children = results[1] as List<ProductModel>;

      emit(ProductsLoaded(categories: categories, products: children));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _resetProducts(
    ResetProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ResetProducts([], []));
  }
}
