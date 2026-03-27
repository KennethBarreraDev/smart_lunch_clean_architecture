import 'package:flutter/material.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class DebitCardsRow extends StatelessWidget {
  const DebitCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        border: Border.all(
          color: AppColors.darkBlue.withOpacity(0.08),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.debit_cards,
            style: TextStyle(
              color: AppColors.darkBlue,
              fontWeight: FontWeight.w300,
              fontSize: 12.0,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 2,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 71, maxHeight: 20),
                child: Image.asset(AppImages.citibanamexLogo),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 61, maxHeight: 20),
                child: Image.asset(AppImages.inbursaLogo),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 71, maxHeight: 20),
                child: Image.asset(AppImages.santanderLogo),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 36, maxHeight: 20),
                child: Image.asset(AppImages.scotiabankLogo),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 36, maxHeight: 20),
                child: Image.asset(AppImages.bancoAztecaLogo),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 45, maxHeight: 20),
                child: Image.asset(AppImages.bbvaLogo),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
