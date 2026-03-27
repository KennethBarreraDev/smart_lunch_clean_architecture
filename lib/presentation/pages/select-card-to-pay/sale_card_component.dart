import 'package:flutter/material.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class SaleCardComponent extends StatelessWidget {
  const SaleCardComponent({
    super.key,
    required this.cardId,
    required this.cardNumber,
    required this.holderName,
    required this.internalId,
    required this.cardBrand,
  });

  final String holderName;
  final String cardNumber;
  final String cardId;
  final int internalId;
  final String cardBrand;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        minVerticalPadding: 12,
        horizontalTitleGap: 12,
        contentPadding: EdgeInsets.zero,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.card_owner,
                  style: TextStyle(
                    color: AppColors.black.withValues(alpha: 0.5),
                    fontSize: 10,
                    fontFamily: "Comfortaa",
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    holderName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: "Comfortaa",
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              "●●●● $cardNumber",
              style: const TextStyle(fontSize: 13),
            ),
            Image.asset(
              AppImages.getCardBrandImage(
                cardBrand.isNotEmpty
                    ? cardBrand
                    : CafeteriaConstants.defaultCardBrand,
              ),
            ),
          ],
        ),
        trailing: Radio<String>(
          value: cardId,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            return AppColors.orange;
          }),
          overlayColor: MaterialStateProperty.all<Color>(
            Colors.transparent,
          ),
        ),
      ),
    );
  }
}