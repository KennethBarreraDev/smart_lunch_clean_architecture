import 'package:flutter/material.dart';
import 'package:smart_lunch/core/base_widgets/buttons/circled_icon.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String bannerType,
  required String bannerMessage,
}) {
  if (bannerType.isEmpty) return;

  final overlay = Overlay.of(context);
  final screenHeight = MediaQuery.of(context).size.height;

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: screenHeight * 0.2,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black26,
              ),
            ],
          ),
          child: Row(
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
              TextButton(
                onPressed: () {
                  overlayEntry.remove(); // ✅ ahora sí funciona
                },
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Color(0xff1e2f97)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 4), () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
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
