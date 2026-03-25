import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/core/constants/user_roles.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/date_utils.dart';
import 'package:smart_lunch/core/utils/unrestricted_mode.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/cafeteria_setting_model.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/session_data.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/sale/widgets/card/presale_date_selector.dart';
import 'package:smart_lunch/presentation/pages/sale/widgets/card/sale_balance_label.dart';
import 'package:smart_lunch/presentation/pages/sale/widgets/card/sale_time_selector.dart';
import 'package:smart_lunch/presentation/pages/sale/widgets/card/today_sale_alert.dart';

class SaleUserCard extends StatelessWidget {
  SaleUserCard({
    super.key,
    required this.sessionData,
    required this.selectedUser,
    required this.selectedDate,
    required this.scheduledHour,
    required this.children,
    required this.cafeteria,
    required this.cafeteriaSetting,
    required this.topMargin,
    required this.isPresale,
    required this.balance,
    required this.onChangeSelectedUser,
    required this.onChangeSelectedDate,
  });

  final SessionData? sessionData;
  final CafeteriaUser? selectedUser;
  final DateTime? selectedDate;
  final String? scheduledHour;
  final List<CafeteriaUser>? children;
  final Cafeteria cafeteria;
  final CafeteriaSetting cafeteriaSetting;
  final double topMargin;
  final bool isPresale;
  final double balance;
  final void Function(CafeteriaUser user)? onChangeSelectedUser;
  final void Function(DateTime date, String? scheduledHour)?
  onChangeSelectedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: topMargin),
          width: 90.w,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: AppColors.dividerColors,
                offset: Offset(0, 6),
                blurRadius: 18,
                spreadRadius: -5,
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 5),
              Text(
                isPresale
                    ? AppLocalizations.of(context)!.student
                    : AppLocalizations.of(context)!.deliver_to,
                style: const TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  fontFamily: "Comfortaa",
                ),
              ),

              sessionData?.userType == UserRole.tutor
                  ? _childrenList(
                      context,
                      children ?? [],
                      selectedUser,
                      onChangeSelectedUser,
                    )
                  : _userRow(context, selectedUser),

              if (isPresale)
                PresaleDateSelector(
                  cafeteria: cafeteria,
                  onChangeSelectedDate: onChangeSelectedDate,
                  defaultText: selectedDate != null
                      ? CustomDateUtils.formatDateForPresale(selectedDate!)
                      : AppLocalizations.of(context)!.select_date,
                ),

              if (!isPresale &&
                  (sessionData?.userType == UserRole.teacher ||
                      (selectedUser?.selfSufficient ?? false)))
                SaleTimeSelector(
                  onChangeSelectedDate: onChangeSelectedDate,
                  scheduledHour: scheduledHour,
                ),

              SaleBalanceLabel(balance: balance),

              if (!isPresale) TodaySaleAlert(),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _childrenList(
  BuildContext context,
  List<CafeteriaUser> children,
  CafeteriaUser? selectedUser,
  Function(CafeteriaUser user)? onChangeSelectedUser,
) {
  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: AppColors.darkBlue.withValues(alpha: 0.15)),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton(
        value: selectedUser,
        items: children
            .map(
              (child) => DropdownMenuItem(
                value: child,
                child: _userRow(context, child),
              ),
            )
            .toList(),
        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.darkBlue),
        onChanged: (CafeteriaUser? child) {
          onChangeSelectedUser!(child!);
        },
      ),
    ),
  );
}

Widget _userRow(BuildContext context, CafeteriaUser? user) {
  return Row(
    children: [
      Container(
        width: 10.w,
        height: 10.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: (user?.user?.picture ?? "").isNotEmpty
                ? NetworkImage(user?.user?.picture ?? "")
                : AssetImage(AppImages.defaultProfileStudentImage)
                      as ImageProvider<Object>,
          ),
        ),
      ),
      SizedBox(width: 2.w),
      SizedBox(
        width: 60.w,
        child: Row(
          children: [
            Expanded(
              child: Text(
                "${user?.user?.firstName} ${user?.user?.lastName}",
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
      ),
    ],
  );
}
