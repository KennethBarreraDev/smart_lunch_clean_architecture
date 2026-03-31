import 'package:flutter/material.dart';
import 'package:smart_lunch/core/base_widgets/modals/modal_action_button.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class StudentInformationModal extends StatelessWidget {
  const StudentInformationModal({
    super.key,
    required this.imageUrl,
    required this.childName,
    required this.dailySpendLimit,
    required this.allergies,
  });

  final String imageUrl;
  final String childName;
  final double dailySpendLimit;
  final List<int> allergies;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: false,
      backgroundColor: AppColors.white,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      titleTextStyle: TextStyle(
        fontSize: 24.0,
        color: AppColors.darkBlue,
        fontFamily: "Comfortaa",
      ),
      title: Text(AppLocalizations.of(context)!.student_information),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: imageUrl.isNotEmpty
                                        ? BoxFit.cover
                                        : BoxFit.contain,
                                    image: imageUrl.isNotEmpty
                                        ? NetworkImage(imageUrl)
                                        : AssetImage(
                                                AppImages
                                                    .defaultProfileStudentImage,
                                              )
                                              as ImageProvider<Object>,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    childName,
                                    style: TextStyle(
                                      color: AppColors.darkBlue,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Comfortaa",
                                      fontSize: 20,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Icon(
                              Icons.monetization_on,
                              color: AppColors.black.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.daily_limit,
                              style: TextStyle(
                                color: AppColors.black.withValues(alpha: 0.6),
                                fontSize: 16,
                                fontFamily: "Comfortaa",
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 11),
                            child: Text(
                              "\$${dailySpendLimit.toString()}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: "Comfortaa",
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Icon(
                              Icons.warning_amber,
                              color: AppColors.black.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.allergies_message,
                              style: TextStyle(
                                color: AppColors.black.withValues(alpha: 0.6),
                                fontSize: 16,
                                fontFamily: "Comfortaa",
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(), //TODO: Add allergies
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ModalActionButton(
                        backgroundColor: AppColors.coral.withValues(
                          alpha: 0.15,
                        ),
                        primaryColor: AppColors.coral,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        text: AppLocalizations.of(context)!.close_button,
                        textFontSize: 20,
                        textFontWeight: FontWeight.w700,
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
