import 'package:flutter/material.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/data/models/product_category_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class ProductCategoryViewer extends StatelessWidget {
   ProductCategoryViewer({super.key, required this.categories});
  List<ProductCategory> categories;


  @override
  Widget build(BuildContext context) {
    return  ColoredBox(
                    color: AppColors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.menu,
                          style: TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Comfortaa",
                            fontSize: 24.0,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: TabBar(
                            indicatorColor: AppColors.orange,
                            labelColor: AppColors.darkBlue,
                            unselectedLabelColor: AppColors.darkBlue.withValues(
                              alpha: 0.25,
                            ),
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            isScrollable: true,
                            tabs: [
                              const Tab(text: "Todos"),
                              ...categories.map(
                                (category) => Tab(text: category.name),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
  }
}