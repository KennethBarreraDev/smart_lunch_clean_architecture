import 'package:flutter/widgets.dart';
import 'package:smart_lunch/core/utils/app_images.dart';

class OpenpayLogosRow extends StatelessWidget {
  const OpenpayLogosRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(AppImages.openpayLogo),
        Image.asset(AppImages.supportLogo),
      ],
    );
  }
}
