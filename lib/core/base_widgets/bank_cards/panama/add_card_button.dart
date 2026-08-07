import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class AddCardButton extends StatelessWidget {
  AddCardButton({
    super.key,
    required this.isPanama,
    required this.cardsAmount,
  });
  final bool isPanama;
  final int cardsAmount;

  @override
  Widget build(BuildContext context) {
    return cardsAmount < 3
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.tuitionGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.tuitionGreen.withValues(alpha: 0.3),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    final route = isPanama
                        ? AppRoutes.registerCroemCard
                        : AppRoutes.registerOpenpayCard;

                    context.pushNamed(AppRoutes.getCleanRouteName(route));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.tuitionGreen.withValues(
                              alpha: 0.18,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: AppColors.tuitionGreen,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          AppLocalizations.of(context)!.add_card,
                          style: TextStyle(
                            color: AppColors.tuitionGreen,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
