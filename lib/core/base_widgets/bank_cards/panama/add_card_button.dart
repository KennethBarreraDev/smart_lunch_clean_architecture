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
            padding: const EdgeInsets.only(bottom: 10, left: 8),
            child: Container(
              padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              child: OutlinedButton(
                onPressed: () {
                  final route = isPanama
                      ? AppRoutes.registerCroemCard
                      : AppRoutes.registerOpenpayCard;

                  context.pushNamed(AppRoutes.getCleanRouteName(route));
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_card_outlined,
                      color: AppColors.lightBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.add_card,
                      style: TextStyle(color: AppColors.lightBlue),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
