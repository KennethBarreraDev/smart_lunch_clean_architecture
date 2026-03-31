import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class UserBalanceCard extends StatelessWidget {
  const UserBalanceCard({
    super.key,
    required this.user,
    required this.familyBalance,
    this.date, 
  });

  final CafeteriaUser? user;
  final String? familyBalance;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final hasImage = (user?.user?.picture ?? "").isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: hasImage ? BoxFit.cover : BoxFit.contain,
                    image: hasImage
                        ? NetworkImage(user?.user?.picture ?? "")
                        : AssetImage(
                            AppImages.defaultProfileStudentImage,
                          ) as ImageProvider<Object>,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user?.user?.firstName ?? ""} ${user?.user?.lastName ?? ""}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Comfortaa",
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),

                  if (date != null)
                    Text(
                      DateFormat(
                        "EEEE',' d 'de' MMMM 'de' y",
                        'es',
                      ).format(date!),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Comfortaa",
                        fontSize: 8,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Text(
                AppLocalizations.of(context)!.homePageStack,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Comfortaa",
                  fontSize: 14,
                ),
              ),
              Text(
                "\$${familyBalance ?? "0"}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Comfortaa",
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}