import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_lunch/blocs/app_version/app_version_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_state.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/blocs/users/users_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/configuration/widgets/language_card.dart';
import 'package:smart_lunch/presentation/pages/configuration/widgets/notifications_card.dart';
import 'package:smart_lunch/presentation/pages/configuration/widgets/payment_methods_card.dart';
import 'package:smart_lunch/presentation/pages/configuration/widgets/user_info_card.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

const double _userInfoCardOverlap = 24;

class ConfigurationPage extends StatelessWidget {
  const ConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppVersionBloc, AppVersionState>(
          listener: (context, state) {
            //TODO: Show version modal
            /*
            showDialog(
              context: context,
              useSafeArea: true,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const AppVersionModal();
              },
            );*/
          },
        ),
      ],
      child: TransparentScaffold(
        selectedOption: "Ajustes",
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 120 + (130 - _userInfoCardOverlap),
                  child: Stack(
                    children: [
                      CustomAppBar(
                        height: 120,
                        image: AppImages.cardImg,
                        showPageTitle: true,
                        pageTitle: AppLocalizations.of(context)!.settings,
                        showDrawer: true,
                        showSchoolLogo: false,
                        hideGoBackText: false,
                        titleAlignment: Alignment.bottomLeft,
                        titleTopPadding: 0.4,
                        titleSize: 28.0,
                      ),

                      Positioned(
                        top: 120 - _userInfoCardOverlap,
                        left: 0,
                        right: 0,
                        child: BlocBuilder<UsersBloc, UsersState>(
                          builder: (context, state) {
                            if (state is! UsersLoaded) {
                              return const SizedBox();
                            }

                            final user = state.mainUser.user;
                            final name =
                                "${user?.firstName ?? ""} ${user?.lastName ?? ""}"
                                    .trim();

                            return UserInfoCard(
                              name: name,
                              familyName: user?.lastName ?? "",
                              imageUrl: user?.picture,
                              onTap: () =>
                                  context.push(AppRoutes.userInformation),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const PaymentMethodsCard(),

                const NotificationsCard(),

                const LanguageCard(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
