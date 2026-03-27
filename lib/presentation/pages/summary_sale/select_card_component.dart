import 'package:flutter/material.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart' show AppImages;
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/data/models/croem_card.dart';
import 'package:smart_lunch/data/models/generic_card.dart';
import 'package:smart_lunch/data/models/openpay_card.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class SelectCardComponent extends StatelessWidget {
  const SelectCardComponent({super.key, required this.selectedCard});

  final GenericCard selectedCard;

  @override
  Widget build(BuildContext context) {
    String name = "";
    String number = "";
    String brand = CafeteriaConstants.defaultCardBrand;

    if (selectedCard is OpenpayCard) {
      final card = selectedCard as OpenpayCard;

      name = card.holderName;
      number = "●●●● ${card.cardNumber}";
      brand = (card.brand?.isNotEmpty ?? false)
          ? card.brand!
          : CafeteriaConstants.defaultCardBrand;
    } else if (selectedCard is CroemCard) {
      final card = selectedCard as CroemCard;

      name = card.cardHolderName ?? "";
      number = card.cardNumber ?? "";
      brand = CafeteriaConstants.defaultCardBrand;
    }

    return GestureDetector(
      onTap: () {
        // navegación
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.card_message,
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      name,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(number, style: const TextStyle(fontSize: 10)),
                  Image.asset(AppImages.getCardBrandImage(brand)),
                  const Icon(Icons.arrow_forward_ios, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
