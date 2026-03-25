import 'package:flutter/material.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class TodaySaleAlert extends StatelessWidget {
  const TodaySaleAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Container(
          height: 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: AppColors.darkBlue.withValues(alpha: 0.15),
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5),
        ),
        Container(
          color: AppColors.lightBlue.withValues(alpha: 0.1),
          child: Row(
            children: [
              Icon(Icons.info, color: AppColors.lightBlue),
              const Padding(padding: EdgeInsets.only(left: 8)),
              Flexible(
                child: Text(
                  AppLocalizations.of(context)!.today_sale_information,
                  style: TextStyle(
                    color: AppColors.lightBlue,
                    fontSize: 10,
                    fontFamily: "Comfortaa",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
