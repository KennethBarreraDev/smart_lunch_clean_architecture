import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/cafeteria_hours/cafeteria_hours_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria_hours/cafeteria_hours_state.dart';
import 'package:smart_lunch/blocs/home_bloc/home_bloc.dart';
import 'package:smart_lunch/blocs/home_bloc/home_event.dart';
import 'package:smart_lunch/blocs/home_bloc/home_state.dart';
import 'package:smart_lunch/core/base_widgets/buttons/circled_icon.dart';
import 'package:smart_lunch/core/constants/countries.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/cafeteria_setting_model.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/presale_model.dart';
import 'package:smart_lunch/data/models/session_data.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/home/widgets/home_body/sales_viewer.dart'
    show SalesViewer;

class SpecialHomeBody extends StatelessWidget {
  SpecialHomeBody({
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
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, animation) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0.1, 0),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slideAnimation, child: child),
            );
          },
          child: state.showMenu
              ? _buildMenuView(
                  context,
                  onMenuTap,
                  onSaleTap,
                  onPresaleTap,
                  onMultisaleTap,
                )
              : _buildSalesView(context),
        );
      },
    );
  }

  Widget _buildMenuView(
    BuildContext context,
    void Function() onMenuTap,
    void Function() onSaleTap,
    void Function() onPresaleTap,
    void Function() onMultisaleTap,
  ) {
    return Column(
      key: const ValueKey("menu"),
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.place_order,
              style: const TextStyle(
                fontFamily: "Comfortaa",
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
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
          ],
        ),

        Expanded(
          child: ListView(
            children: [
              BlocBuilder<CafeteriaHoursBloc, CafeteriaHoursState>(
                builder: (context, state) {
                  return (state.isOpen &&
                          (cafeteriaSetting?.mobileSales ?? false))
                      ? _buildCustomCard(
                          context: context,
                          onTap: () {
                            onSaleTap();
                          },
                          title: AppLocalizations.of(context)!.sale,
                          description: AppLocalizations.of(
                            context,
                          )!.sale_description,
                          imagePath: AppImages.panamaSale,
                          color: AppColors.orange,
                        )
                      : const SizedBox();
                },
              ),

              if ((cafeteriaSetting?.presales ?? false))
                _buildCustomCard(
                  context: context,
                  onTap: () {
                    onPresaleTap();
                  },
                  title: AppLocalizations.of(context)!.presales,
                  description: AppLocalizations.of(
                    context,
                  )!.presale_description,
                  imagePath: AppImages.panamaPresale,
                  color: AppColors.lightBlue,
                ),

              if ((Countries.isPanama(cafeteria?.school?.country ?? "") &&
                  (cafeteriaSetting?.presales ?? false)))
                _buildCustomCard(
                  context: context,
                  onTap: () {
                    onMultisaleTap();
                  },
                  title: AppLocalizations.of(context)!.multisale,
                  description: AppLocalizations.of(
                    context,
                  )!.presale_description,
                  imagePath: AppImages.panama_multisale,
                  color: AppColors.tuitionRed,
                ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    context.read<HomeBloc>().add(ToggleMenuEvent());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list, color: AppColors.orange, size: 25),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.view_today_purchases,
                          style: TextStyle(
                            color: AppColors.orange,
                            fontFamily: "Comfortaa",
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSalesView(BuildContext context) {
    return Column(
      key: const ValueKey("sales"),
      children: [
        GestureDetector(
          onTap: () {
            context.read<HomeBloc>().add(ToggleMenuEvent());
          },
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 25,
              top: 30,
              bottom: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.coral.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.close_button,
                    style: TextStyle(color: AppColors.coral),
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildCustomCard({
    required BuildContext context,
    required VoidCallback onTap,
    required String title,
    required String description,
    required String imagePath,
    required Color color,
    double opacity = 0.5,
    double containerHeight = 90,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          height: containerHeight,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: color,
                          fontSize: 20,
                          fontFamily: "Comfortaa",
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontFamily: "Comfortaa",
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset(
                imagePath,
                height: 20.w,
                width: 20.w,
                opacity: AlwaysStoppedAnimation<double>(opacity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
