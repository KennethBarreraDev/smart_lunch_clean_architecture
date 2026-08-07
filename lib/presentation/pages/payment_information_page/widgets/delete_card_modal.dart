import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_graphics/vector_graphics.dart';
import 'package:smart_lunch/core/base_widgets/modals/custom_modal.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class DeleteCardModal extends StatelessWidget {
  const DeleteCardModal({
    super.key,
    required this.cardLastDigits,
    required this.onConfirm,
  });

  final String cardLastDigits;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return CustomModal(
      title: AppLocalizations.of(context)!.remove_card,
      buttonText: AppLocalizations.of(context)!.remove_card,
      buttonColor: const Color(0xFFFBE1E1),
      buttonTextColor: const Color(0xFFE9585A),
      onButtonPressed: () {
        Navigator.pop(context);
        onConfirm();
      },
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            child: SvgPicture(AssetBytesLoader(AppImages.deleteCardModal)),
          ),
          const SizedBox(height: 16),
          Text(
            "${AppLocalizations.of(context)!.remove_card_warning} $cardLastDigits?",
          ),
        ],
      ),
    );
  }
}
