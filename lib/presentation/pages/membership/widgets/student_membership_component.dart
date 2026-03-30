import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class StudentMembershipComponent extends StatelessWidget {
  const StudentMembershipComponent({
    super.key,
    required this.image,
    required this.name,
    required this.lastName,
    required this.studentId,
    required this.membershipAmount,
    required this.minMembeshipAmount,

    required this.removeItems,
    required this.addItems,
    required this.expiration,
  });

  final String image;
  final String name;
  final String lastName;
  final int studentId;
  final int membershipAmount;
  final int minMembeshipAmount;
  final void Function(int studentId) removeItems;
  final void Function(int studentId) addItems;
  final String expiration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 15.w,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: image.isNotEmpty
                            ? NetworkImage(image)
                            : AssetImage(AppImages.defaultProfileStudentImage)
                                  as ImageProvider<Object>,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$name $lastName",
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 16,
                          fontFamily: "Comfortaa",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${AppLocalizations.of(context)!.membership_expiration}: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(expiration))}",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Comfortaa",
                          color:
                              DateTime.parse(
                                expiration,
                              ).isBefore(DateTime.now())
                              ? AppColors.coral
                              : AppColors.tuitionGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: AppColors.orange,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          removeItems.call(studentId);
                        },
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "$membershipAmount",
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle, color: AppColors.orange),
                        iconSize: 30,
                        onPressed: () {
                          addItems.call(studentId);
                        },
                      ),
                    ],
                  ),
                  Text(
                    "\$${(membershipAmount * CafeteriaConstants.panamaMembershipPrice).toStringAsFixed(2)}",
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 15,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 2),
          Divider(color: AppColors.darkBlue.withValues(alpha: 0.2)),
          const SizedBox(height: 21),
        ],
      ),
    );
  }
}
