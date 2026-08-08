import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_lunch/blocs/app_version/app_version_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_state.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_bloc.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_event.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/selected_child/tabs/edit_profile_tab.dart';
import 'package:smart_lunch/presentation/pages/selected_child/tabs/selected_child_gestion_tab.dart';
import 'package:smart_lunch/presentation/pages/selected_child/widget/selected_child_tab.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class SelectedChildPage extends StatelessWidget {
  const SelectedChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppVersionBloc, AppVersionState>(
          listener: (context, state) {
            // TODO: Show version modal
          },
        ),

        BlocListener<SelectedUserBloc, SelectedUserState>(
          listenWhen: (previous, current) {
            return current is SelectedUserLoaded &&
                previous is! SelectedUserDataLoaded;
          },
          listener: (context, state) {
            if (state is SelectedUserLoaded) {
              context.read<SelectedUserBloc>().add(
                LoadSelectedUserData(cafeteriaUserId: state.cafeteriaUserId),
              );
            }
          },
        ),

        BlocListener<SelectedUserBloc, SelectedUserState>(
          listener: (context, state) {
            if (state is SelectedUserInitial) {
              context.go(AppRoutes.children);
            }
          },
        ),
      ],
      child: TransparentScaffold(
        selectedOption: "Hijos",
        body: BlocBuilder<SelectedUserBloc, SelectedUserState>(
          builder: (context, state) {
            if (state is SelectedUserLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SelectedUserError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.error_message}: ${state.message}',
                    ),
                    ElevatedButton(
                      onPressed: () => context.go(AppRoutes.children),
                      child: Text(AppLocalizations.of(context)!.go_back_button),
                    ),
                  ],
                ),
              );
            }

            if (state is SelectedUserDataLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    height: 120,
                    image: AppImages.cardImg,
                    showPageTitle: true,
                    pageTitle:
                        '${state.userData.user!.firstName} ${state.userData.user!.lastName}',
                    showDrawer: false,
                    showSchoolLogo: false,
                    hideGoBackText: false,
                    titleAlignment: Alignment.bottomLeft,
                    titleTopPadding: 0.4,
                    titleSize: 32.0,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SelectedChildTab(
                      children: [EditProfileTab(), SelectedChildGestionTab()],
                    ),
                  ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
