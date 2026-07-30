import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/product_restriction/product_restriction_event.dart';
import 'package:smart_lunch/blocs/product_restriction/product_restriction_state.dart';
import 'package:smart_lunch/data/models/product_restrictiction_model.dart';
import 'package:smart_lunch/data/repositories/product_restriction/product_restriction_respository.dart';

class ProductRestrictionBloc
    extends Bloc<ProductRestrictionEvent, ProductRestrictionState> {
  final ProductRestrictionRepository repository;

  ProductRestrictionBloc(this.repository)
    : super(ProductRestrictionInitial()) {
    on<LoadProductRestrictions>(_onLoadProductRestrictions);
    on<RefreshProductRestrictions>(_onRefreshProductRestrictions);
    on<ToggleProductRestriction>(_onToggleProductRestriction);
    on<UpdateProductRestrictionLimit>(_onUpdateProductRestrictionLimit);
  }

  Future<void> _onLoadProductRestrictions(
    LoadProductRestrictions event,
    Emitter<ProductRestrictionState> emit,
  ) async {
    emit(ProductRestrictionLoading());

    try {
      final restrictions = await repository.loadProductRestrictions(
        studentId: event.studentId,
      );
      emit(ProductRestrictionLoaded(restrictions));
    } catch (e) {
      emit(
        ProductRestrictionError(
          'Error al cargar restricciones: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRefreshProductRestrictions(
    RefreshProductRestrictions event,
    Emitter<ProductRestrictionState> emit,
  ) async {
    add(LoadProductRestrictions(studentId: event.studentId));
  }

  Future<void> _onToggleProductRestriction(
    ToggleProductRestriction event,
    Emitter<ProductRestrictionState> emit,
  ) async {
    final currentRestrictions = _currentRestrictions();

    final index = currentRestrictions.indexWhere(
      (r) => r.student == event.studentId && r.product == event.productId,
    );

    try {
      if (index == -1) {
        if (!event.isActive) {
          emit(ProductRestrictionLoaded(currentRestrictions));
          return;
        }

        final created = await repository.createProductRestriction(
          studentId: event.studentId,
          productId: event.productId,
          restrictionType: "prohibited",
        );

        emit(ProductRestrictionLoaded([...currentRestrictions, created]));
      } else {
        final updated = await repository.updateRestrictionType(
          id: currentRestrictions[index].id,
          restrictionType: event.isActive ? "prohibited" : "limit",
        );

        final updatedRestrictions = List<ProductRestriction>.from(
          currentRestrictions,
        );
        updatedRestrictions[index] = updated;

        emit(ProductRestrictionLoaded(updatedRestrictions));
      }
    } catch (e) {
      emit(
        ProductRestrictionActionError(
          'Error al actualizar la restricción: ${e.toString()}',
          currentRestrictions,
        ),
      );
    }
  }

  Future<void> _onUpdateProductRestrictionLimit(
    UpdateProductRestrictionLimit event,
    Emitter<ProductRestrictionState> emit,
  ) async {
    final currentRestrictions = _currentRestrictions();

    final index = currentRestrictions.indexWhere(
      (r) => r.student == event.studentId && r.product == event.productId,
    );

    final isProhibited = event.value == "prohibited";
    final restrictionType = isProhibited ? "prohibited" : "limit";
    final quantity = isProhibited
        ? 1
        : (int.tryParse(event.value) ?? 1).clamp(1, 1 << 30);

    try {
      if (index == -1) {
        final created = await repository.createProductRestriction(
          studentId: event.studentId,
          productId: event.productId,
          restrictionType: restrictionType,
          quantity: quantity,
        );

        emit(ProductRestrictionLoaded([...currentRestrictions, created]));
      } else {
        final updated = await repository.updateProductRestrictionLimit(
          id: currentRestrictions[index].id,
          quantity: quantity,
          restrictionType: restrictionType,
        );

        final updatedRestrictions = List<ProductRestriction>.from(
          currentRestrictions,
        );
        updatedRestrictions[index] = updated;

        emit(ProductRestrictionLoaded(updatedRestrictions));
      }
    } catch (e) {
      emit(
        ProductRestrictionActionError(
          'Error al actualizar la restricción: ${e.toString()}',
          currentRestrictions,
        ),
      );
    }
  }

  List<ProductRestriction> _currentRestrictions() {
    final currentState = state;

    if (currentState is ProductRestrictionLoaded) {
      return List<ProductRestriction>.from(currentState.restrictions);
    }

    if (currentState is ProductRestrictionActionError) {
      return List<ProductRestriction>.from(currentState.restrictions);
    }

    return [];
  }
}
