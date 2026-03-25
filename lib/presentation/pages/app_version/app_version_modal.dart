import 'package:flutter/material.dart';
import 'package:smart_lunch/core/base_widgets/modals/modal_action_button.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';

class AppVersionModal extends StatelessWidget {
  const AppVersionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      scrollable: true,
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 5),
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      titleTextStyle: TextStyle(
        color: AppColors.darkBlue,
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
      ),
      title: Text(
        AppLocalizations.of(context)!.new_available_version,
        style: const TextStyle(fontFamily: "Comfortaa"),
      ),
      content: Container(
        color: AppColors.white,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 56),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage(AppImages.updateAppImage),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.app_benefits,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Comfortaa",
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ModalActionButton(
                  backgroundColor: AppColors.orange.withValues(alpha: 0.15),
                  primaryColor: AppColors.orange,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  onTap: () {
                    if (Platform.isAndroid) {
                      launchUrl(
                        Uri.parse(
                          "https://play.google.com/store/apps/details?id=com.ideapp.smart.lunch.smart_lunch",
                        ),
                        mode: LaunchMode.externalApplication,
                      );
                    } else if (Platform.isIOS) {
                      launchUrl(
                        Uri.parse(
                          "https://apps.apple.com/mx/app/smart-lunch/id6470789431",
                        ),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  largeIcon: Icons.security_update,
                  text: AppLocalizations.of(context)!.update_message,
                  textFontSize: 20,
                  textFontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
