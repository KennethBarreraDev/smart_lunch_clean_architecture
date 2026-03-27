import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class SummarySelectedChild extends StatelessWidget {
  SummarySelectedChild({
    super.key,
    required this.selectedUser,
    required this.selectedDate,
  });

  CafeteriaUser selectedUser;
  String selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.order_information,
            style: TextStyle(
              color: AppColors.darkBlue,
              fontWeight: FontWeight.w600,
              fontSize: 12.0,
              fontFamily: "Comfortaa",
            ),
          ),
          Divider(color: AppColors.darkBlue.withValues(alpha: 0.15)),
          const SizedBox(height: 3),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.11,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: ((selectedUser.user?.picture ?? "").isNotEmpty)
                        ? NetworkImage(selectedUser.user?.picture ?? "")
                        : AssetImage(AppImages.defaultProfileStudentImage)
                              as ImageProvider<Object>,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "${selectedUser.user?.firstName} ${selectedUser.user?.lastName}",
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.delivery_date,
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontFamily: "Comfortaa",
            ),
          ),
          Text(
            selectedDate,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "Comfortaa",
            ),
          ),
        ],
      ),
    );
  }
}
