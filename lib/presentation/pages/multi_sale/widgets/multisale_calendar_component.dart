import 'package:flutter/material.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class MultisaleCalendarComponent extends StatelessWidget {
  const MultisaleCalendarComponent({
    super.key,
    required this.date,
    required this.selected,
    required this.salePrice,
    this.onTap,
  });

  final String date;
  final bool selected;
  final double salePrice;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.93,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: selected
                          ? AppColors.tuitionGreen.withValues(alpha: 0.2)
                          : AppColors.orange.withValues(alpha: 0.2),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.calendar_month,
                      color: selected
                          ? AppColors.tuitionGreen
                          : AppColors.orange,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    date,
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Comfortaa",
                      fontSize: 9,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        salePrice > 0
                            ? "\$$salePrice"
                            : AppLocalizations.of(context)!.no_order,
                        style: TextStyle(
                          color: AppColors.black.withValues(alpha: 0.4),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Comfortaa",
                          fontSize: 8,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: AppColors.darkBlue.withValues(alpha: 0.15),
                      ),
                    ],
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
