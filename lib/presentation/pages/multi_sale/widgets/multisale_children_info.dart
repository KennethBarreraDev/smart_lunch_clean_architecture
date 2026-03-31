import 'package:flutter/material.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/multi_sale/widgets/student_information_modal.dart';

class MultisaleChildComponent extends StatelessWidget {
  const MultisaleChildComponent({
    super.key,
    required this.imageUrl,
    required this.childName,
    required this.dailySpendLimit,
    required this.allergies,
    this.onTap,
  });

  final String imageUrl;
  final String childName;
  final double dailySpendLimit;
  final List<int> allergies;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.93,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: AppColors.white,
          ),
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: imageUrl.isNotEmpty
                                ? BoxFit.cover
                                : BoxFit.contain,
                            image: imageUrl.isNotEmpty
                                ? NetworkImage(imageUrl)
                                : AssetImage(
                                        AppImages.defaultProfileStudentImage,
                                      )
                                      as ImageProvider<Object>,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            childName,
                            style: TextStyle(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Comfortaa",
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            useSafeArea: true,
                            builder: (BuildContext context) {
                              return StudentInformationModal(
                                imageUrl: imageUrl,
                                childName: childName,
                                dailySpendLimit: dailySpendLimit,
                                allergies: allergies,
                              );
                            },
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.information_text,
                          style: TextStyle(
                            color: AppColors.lightBlue,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chevron_right,
                    size: 50,
                    color: AppColors.darkBlue.withValues(alpha: 0.15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
