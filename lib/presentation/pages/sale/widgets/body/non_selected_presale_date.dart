import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class NonSelectedPresaleDate extends StatelessWidget {
  const NonSelectedPresaleDate({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            width: 55.w,
            height: 55.w,
            decoration:  BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(AppImages.pickSaleDateLogo),
              ),
            ),
          ),
          Center(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.select_delivery_date,
                    style: TextStyle(
                      color: AppColors.dividerColors.withValues(alpha: 0.6),
                      fontSize: 20,
                      fontFamily: "Comfortaa",
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
