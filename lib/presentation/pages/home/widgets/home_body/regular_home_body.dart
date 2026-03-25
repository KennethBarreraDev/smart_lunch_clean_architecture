import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_lunch/blocs/cafeteria_hours/cafeteria_hours_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria_hours/cafeteria_hours_state.dart';
import 'package:smart_lunch/blocs/sales/sales_bloc.dart';
import 'package:smart_lunch/blocs/sales/sales_event.dart';
import 'package:smart_lunch/core/base_widgets/buttons/circled_icon.dart';
import 'package:smart_lunch/core/base_widgets/buttons/rounded_button.dart';
import 'package:smart_lunch/core/constants/countries.dart';
import 'package:smart_lunch/core/constants/user_roles.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/unrestricted_mode.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/cafeteria_setting_model.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/presale_model.dart';
import 'package:smart_lunch/data/models/session_data.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/home/widgets/home_body/sales_viewer.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class RegularHomeBody extends StatelessWidget {
  RegularHomeBody({
    super.key,
    required this.cafeteriaUser,
    required this.cafeteria,
    required this.cafeteriaSetting,
    required this.sessionData,
    required this.presales,
    required this.dailySales,
    required this.onMenuTap,
    required this.onSaleTap,
    required this.onPresaleTap,
    required this.onMultisaleTap,
  });

  final CafeteriaUser? cafeteriaUser;
  final Cafeteria? cafeteria;
  final CafeteriaSetting? cafeteriaSetting;
  final SessionData? sessionData;
  final List<Presale> presales;
  final List<Presale> dailySales;
  final VoidCallback onMenuTap;
  final VoidCallback onSaleTap;
  final VoidCallback onPresaleTap;
  final VoidCallback onMultisaleTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if ((cafeteria?.menu ?? "").isNotEmpty)
              GestureDetector(
                onTap: () {
                  onMenuTap();
                },
                child: CircledIcon(
                  color: AppColors.gold,
                  iconData: Icons.menu_book,
                  height: 36,
                  width: 48,
                  padding: 6,
                ),
              ),
            BlocBuilder<CafeteriaHoursBloc, CafeteriaHoursState>(
              builder: (context, state) {
                if (!UnrestrictedMode.value &&
                    (!state.isOpen ||
                        !(cafeteriaSetting?.mobileSales ?? false))) {
                  return SizedBox();
                }
                return RoundedButton(
                  color: AppColors.tuitionGreen,
                  iconData: Icons.shopping_cart,
                  text: AppLocalizations.of(context)!.sale,
                  onTap: () {
                  
                    onSaleTap();
                  },
                );
              },
            ),

            const SizedBox(width: 24),
            if (UnrestrictedMode.value ||
                (cafeteriaSetting?.presales ?? false) &&
                    sessionData?.userType == UserRole.tutor)
              RoundedButton(
                color: AppColors.lightBlue,
                iconData: Icons.add_shopping_cart,
                text: AppLocalizations.of(context)!.presale,
                onTap: () {
                  onPresaleTap();
                },
              ),
          ],
        ),

        SizedBox(height: 10),
        if (Countries.isPanama(cafeteria?.school?.country ?? "") &&
            (cafeteriaSetting?.presales ?? false))
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                color: AppColors.lightBlue,
                iconData: Icons.add_shopping_cart,
                text: AppLocalizations.of(context)!.multisale,
                onTap: () {
                  onMultisaleTap();
                },
              ),
            ],
          ),

        Expanded(
          child: SalesViewer(
            mainUser: cafeteriaUser!,
            dailySales: dailySales,
            presales: presales,
            cafeteria: cafeteria,
          ),
        ),
      ],
    );
  }
}
