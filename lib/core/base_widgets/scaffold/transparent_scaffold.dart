import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_event.dart';
import 'package:smart_lunch/blocs/session/session_bloc.dart';
import 'package:smart_lunch/blocs/session/session_state.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/blocs/users/users_state.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/drawer_option.dart';
import 'package:smart_lunch/core/constants/user_roles.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/session_data.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class TransparentScaffold extends StatelessWidget {
  const TransparentScaffold({
    super.key,
    required this.body,
    required this.selectedOption,
    this.showDrawer = true,
  });

  final Widget? body;
  final String selectedOption;
  final bool showDrawer;

  @override
  Widget build(BuildContext context) {
    final cafeteriaUser = context.select<UsersBloc, CafeteriaUser?>((bloc) {
      final state = bloc.state;
      if (state is UsersLoaded) {
        return state.mainUser;
      }
      return null;
    });

    final authUser = context.select<SessionBloc, SessionData?>((bloc) {
      final state = bloc.state;
      if (state is SessionAuthenticated) {
        return state.sessionData;
      }
      return null;
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.transparent,
          ),
          elevation: 0,
          backgroundColor: AppColors.transparent,
          leading: Container(),
        ),
      ),
      drawer: showDrawer
          ? Drawer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.orange, AppColors.coral],
                    begin: FractionalOffset(0, 0),
                    end: FractionalOffset(0, 1),
                    stops: [0, 1],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            height: 50.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(height: 40),

                                Text(
                                  AppLocalizations.of(context)!.menu,
                                  style: const TextStyle(
                                    color: Color(0xfff8fdff),
                                    fontSize: 20.0,
                                    fontFamily: "Comfortaa",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),

                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.white.withValues(
                                        alpha: 0.25,
                                      ),
                                      width: 3,
                                    ),
                                  ),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit:
                                            (cafeteriaUser?.user?.picture ?? "")
                                                .isNotEmpty
                                            ? BoxFit.cover
                                            : BoxFit.contain,
                                        image:
                                            (cafeteriaUser?.user?.picture ?? "")
                                                .isNotEmpty
                                            ? NetworkImage(
                                                cafeteriaUser!.user!.picture!,
                                              )
                                            : AssetImage(
                                                    AppImages
                                                        .defaultProfileStudentImage,
                                                  )
                                                  as ImageProvider,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                Text(
                                  "${cafeteriaUser?.user?.firstName} ${cafeteriaUser?.user?.lastName}",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 24.0,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                                const SizedBox(height: 4),

                                Text(
                                  authUser?.userType == UserRole.tutor
                                      ? AppLocalizations.of(context)!.tutor
                                      : authUser?.userType == UserRole.teacher
                                      ? AppLocalizations.of(context)!.teacher
                                      : AppLocalizations.of(context)!.student,
                                  style: TextStyle(
                                    color: AppColors.white.withValues(
                                      alpha: 0.5,
                                    ),
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                  height: 2,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),

                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.5, // Ajusta según necesites
                            padding: EdgeInsets.zero,
                            children: [
                              DrawerOption(
                                title: AppLocalizations.of(context)!.home,
                                icon: Icons.house,
                                isSelected: selectedOption == "Inicio",
                                route: AppRoutes.homeRoute,

                                onTap: () {
                                  context.read<CafeteriaBloc>().add(
                                    LoadCafeteria(),
                                  );
                                 
                                },
                              ),

                              if (authUser?.userType == UserRole.tutor)
                                DrawerOption(
                                  title: AppLocalizations.of(context)!.children,
                                  icon: Icons.face,
                                  isSelected: selectedOption == "Hijos",
                                  route: AppRoutes.homeRoute,
                                ),

                              DrawerOption(
                                title: AppLocalizations.of(context)!.history,
                                icon: Icons.bar_chart,
                                isSelected: selectedOption == "Historial",
                                route: AppRoutes.homeRoute,
                                onTap: () {
                                  // historyProvider.initialLoad(
                                  //   mainProvider.accessToken,
                                  //   mainProvider.cafeteriaId,
                                  //   int.parse(mainProvider.studentId),
                                  //   mainProvider.userType,
                                  // );
                                },
                              ),

                              DrawerOption(
                                title: AppLocalizations.of(context)!.settings,
                                icon: Icons.settings,
                                isSelected: selectedOption == "Ajustes",
                                route: AppRoutes.homeRoute,
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: Column(
                              children: [
                                Divider(color: AppColors.white),
                                ListTile(
                                  onTap: () {},
                                  horizontalTitleGap: 0,
                                  contentPadding: const EdgeInsets.only(
                                    top: 20,
                                    left: 16,
                                    right: 16,
                                  ),
                                  leading: Icon(
                                    Icons.logout,
                                    color: AppColors.white,
                                    size: 32,
                                  ),
                                  title: Text(
                                    AppLocalizations.of(context)!.log_out,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: body,
    );
  }
}
