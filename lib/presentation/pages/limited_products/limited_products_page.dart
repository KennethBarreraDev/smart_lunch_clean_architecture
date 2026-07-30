import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_state.dart';
import 'package:smart_lunch/blocs/classification/classification_bloc.dart';
import 'package:smart_lunch/blocs/classification/classification_event.dart';
import 'package:smart_lunch/blocs/classification/classification_state.dart';
import 'package:smart_lunch/blocs/product_restriction/product_restriction_bloc.dart';
import 'package:smart_lunch/blocs/product_restriction/product_restriction_event.dart';
import 'package:smart_lunch/blocs/product_restriction/product_restriction_state.dart';
import 'package:smart_lunch/blocs/products/products_state.dart';
import 'package:smart_lunch/blocs/products/products_bloc.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_bloc.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/cards/empty_products_state.dart';
import 'package:smart_lunch/core/base_widgets/cards/limited_permission_card.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/base_widgets/tabs_reutilizables/tab_subtitle.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/data/models/classification_model.dart';
import 'package:smart_lunch/data/models/product_model.dart';
import 'package:smart_lunch/data/models/product_restrictiction_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class LimitedProductsPage extends StatefulWidget {
  const LimitedProductsPage({super.key});

  @override
  State<LimitedProductsPage> createState() => _LimitedProductsPageState();
}

class _LimitedProductsPageState extends State<LimitedProductsPage> {
  int? _studentId;

  @override
  void initState() {
    super.initState();

    final classificationBloc = context.read<ClassificationBloc>();
    if (classificationBloc.state is ClassificationInitial) {
      classificationBloc.add(const LoadClassifications());
    }

    _studentId = _resolveStudentId(context.read<SelectedUserBloc>().state);

    if (_studentId != null) {
      context.read<ProductRestrictionBloc>().add(
        LoadProductRestrictions(studentId: _studentId!),
      );
    }
  }

  int? _resolveStudentId(SelectedUserState state) {
    if (state is SelectedUserDataLoaded) {
      return state.userData.id;
    }
    if (state is SelectedUserLoaded) {
      return state.cafeteriaUserId;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppVersionBloc, AppVersionState>(
          listener: (context, state) {
            //TODO: Show version modal
          },
        ),
        BlocListener<ProductRestrictionBloc, ProductRestrictionState>(
          listenWhen: (previous, current) =>
              current is ProductRestrictionActionError,
          listener: (context, state) {
            if (state is ProductRestrictionActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: TransparentScaffold(
        selectedOption: "Hijos",
        body: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(
                  height: 130,
                  image: AppImages.cardImg,
                  showPageTitle: true,
                  pageTitle: AppLocalizations.of(context)!.limited_products,
                  showDrawer: false,
                  showSchoolLogo: false,
                  hideGoBackText: false,
                  titleAlignment: Alignment.bottomLeft,
                  titleTopPadding: 0.4,
                  titleSize: 32.0,
                ),
                Expanded(
                  child: _studentId == null
                      ? const Center(child: CircularProgressIndicator())
                      : BlocBuilder<ClassificationBloc, ClassificationState>(
                          builder: (context, state) {
                            if (state is ClassificationLoading ||
                                state is ClassificationInitial) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (state is ClassificationError) {
                              return Center(child: Text(state.message));
                            }

                            final classifications =
                                state is ClassificationLoaded
                                ? state.classifications
                                : <Classification>[];

                            final tabNames = <String>[
                              'Todos',
                              ...classifications.map((c) => c.name),
                            ];

                            final tabViews = <Widget>[
                              _ClassificationProductsTab(
                                studentId: _studentId!,
                                classification: null,
                                allClassifications: classifications,
                              ),
                              ...classifications.map(
                                (c) => _ClassificationProductsTab(
                                  studentId: _studentId!,
                                  classification: c,
                                  allClassifications: classifications,
                                ),
                              ),
                            ];

                            return ReusableTabSubtitle(
                              tabNames: tabNames,
                              tabViews: tabViews,
                            );
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassificationProductsTab extends StatelessWidget {
  const _ClassificationProductsTab({
    required this.studentId,
    required this.classification,
    required this.allClassifications,
  });

  final int studentId;
  final Classification? classification;
  final List<Classification> allClassifications;

  @override
  Widget build(BuildContext context) {
    final productsState = context.watch<ProductsBloc>().state;

    if (productsState is! ProductsLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<ProductModel> products = classification == null
        ? productsState.products
        : productsState.products
              .where((p) => p.category == classification!.id)
              .toList();

    return BlocBuilder<ProductRestrictionBloc, ProductRestrictionState>(
      builder: (context, state) {
        if (state is ProductRestrictionLoading ||
            state is ProductRestrictionInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductRestrictionError) {
          return Center(child: Text(state.message));
        }

        final List<ProductRestriction> restrictions = state
            is ProductRestrictionLoaded
            ? state.restrictions
            : state is ProductRestrictionActionError
            ? state.restrictions
            : <ProductRestriction>[];

        if (products.isEmpty) {
          return const EmptyProductsState();
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: products.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final product = products[index];

            ProductRestriction? restriction;
            for (final r in restrictions) {
              if (r.student == studentId && r.product == product.id) {
                restriction = r;
                break;
              }
            }

            final String? currentValue = restriction == null
                ? null
                : restriction.restrictionType == "prohibited"
                ? "prohibited"
                : restriction.quantity.toString();

            final categoryName = classification?.name ?? _categoryNameFor(product);

            return LimitPermissionCard(
              image: (product.imageUrl ?? '').isNotEmpty
                  ? NetworkImage(product.imageUrl!)
                  : AssetImage(AppImages.defaultProductImage)
                        as ImageProvider,
              productName: product.name ?? '',
              category: categoryName,
              description: product.description ?? '',
              value: currentValue,
              onChanged: (value) {
                if (value == null) return;

                context.read<ProductRestrictionBloc>().add(
                  UpdateProductRestrictionLimit(
                    studentId: studentId,
                    productId: product.id!,
                    value: value,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String _categoryNameFor(ProductModel product) {
    for (final c in allClassifications) {
      if (c.id == product.category) {
        return c.name;
      }
    }
    return '';
  }
}
