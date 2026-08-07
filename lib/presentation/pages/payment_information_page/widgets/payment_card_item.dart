import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_graphics/vector_graphics.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/data/models/openpay_card.dart';

class PaymentCardItem extends StatelessWidget {
  const PaymentCardItem({
    super.key,
    required this.card,
    required this.isPrincipal,
    required this.onDelete,
  });

  final OpenpayCard card;
  final bool isPrincipal;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final brand = (card.brand?.isNotEmpty ?? false)
        ? card.brand!
        : CafeteriaConstants.defaultCardBrand;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: double.infinity,
              height: 170,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SvgPicture(
                    AssetBytesLoader(AppImages.cardImg),
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                card.holderName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: 44,
                              height: 30,
                              child: Image.asset(
                                AppImages.getCardBrandImage(brand),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "●●●● ${card.cardNumber}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              "${card.expirationMonth}/${card.expirationYear}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (isPrincipal) ...[
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "Principal",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: -12,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFBE1E1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFE9585A),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
