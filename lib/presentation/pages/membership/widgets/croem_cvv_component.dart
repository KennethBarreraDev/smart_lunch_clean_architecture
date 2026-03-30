import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/core/utils/cards_utils.dart';
import 'package:smart_lunch/data/models/croem_card.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class CroemCvvComponent extends StatelessWidget {
  const CroemCvvComponent({
    super.key,
    required this.card,
    required this.cvvController,
    required this.paymentError,
    required this.totalAmont,
    required this.cardTap,
    required this.loading,
  });
  final CroemCard card;
  final TextEditingController cvvController;
  final bool paymentError;
  final String totalAmont;
  final void Function() cardTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90.w,
      height: 450,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.card_cvv,
              style: const TextStyle(
                fontFamily: "Confortaa",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.black.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    card.cardHolderName ?? "",
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 5)),
                  Text(
                    " ${card.cardNumber}",
                    style: const TextStyle(fontSize: 10),
                  ),
                  CardsUtils.getCardBrand(card.cardNumber ?? "").isNotEmpty
                      ? Image.asset(
                          AppImages.getCardBrandImage(
                            CardsUtils.getCardBrand(card.cardNumber ?? ""),
                          ),
                        )
                      : Image.asset(
                          AppImages.getCardBrandImage(
                            CafeteriaConstants.defaultCardBrand,
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              maxLength: 16,
              enabled: true,
              controller: cvvController,
              decoration: const InputDecoration(
                labelText: "CVV",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            paymentError
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColors.coral.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.cvv_error,
                                          style: TextStyle(
                                            color: AppColors.coral,
                                            fontSize: 10,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Icon(
                                          Icons.credit_card_off,
                                          color: AppColors.coral,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                : const SizedBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.total_price,
                  style: TextStyle(
                    fontFamily: "Outfit",
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$$totalAmont",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: cardTap,
              child: Row(
                children: [
                  Expanded(
                    child: loading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.tuitionGreen,
                              ),
                            ],
                          )
                        : Center(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.tuitionGreen.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.credit_score_outlined,
                                      color: AppColors.tuitionGreen,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.continuePayment,
                                      style: TextStyle(
                                        color: AppColors.tuitionGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
