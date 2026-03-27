import 'package:flutter/material.dart';
import 'package:smart_lunch/core/base_widgets/buttons/circled_icon.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String bannerType,
  required String bannerMessage,
}) {
  if (bannerType.isEmpty) return;

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    backgroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getIconFromBannerType(bannerType),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            bannerMessage,
            style: TextStyle(
              color: AppColors.darkBlue,
              fontWeight: FontWeight.w300,
              fontSize: 18.0,
            ),
          ),
        ),
      ],
    ),
    action: SnackBarAction(
      label: 'Cerrar',
      textColor: const Color(0xff1e2f97),
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
    duration: const Duration(seconds: 4),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

Widget getIconFromBannerType(String bannerType) {
  if (bannerType == BannerTypes.successBanner.type) {
    return CircledIcon(
      iconData: Icons.check_circle,
      color: AppColors.tuitionGreen,
      padding: 7,
    );
  } else if (bannerType == BannerTypes.warningBanner.type) {
    return CircledIcon(
      iconData: Icons.warning,
      color: AppColors.gold,
      padding: 7,
    );
  } else if (bannerType == BannerTypes.errorBanner.type) {
    return CircledIcon(
      iconData: Icons.report,
      color: AppColors.tuitionRed,
      padding: 7,
    );
  } else {
    return CircledIcon(
      iconData: Icons.info,
      color: AppColors.lightBlue,
      padding: 7,
    );
  }
}

enum BannerTypes {
  successBanner("success"),
  warningBanner("warning"),
  errorBanner("error"),
  infoBanner("info"),
  unknownError("unknown");

  const BannerTypes(this.type);
  final String type;
}
