import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_lunch/blocs/app_version/app_version_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_state.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_bloc.dart';
import 'package:smart_lunch/blocs/selected_user/selected_user_event.dart';
import 'package:smart_lunch/blocs/users/user_event.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/blocs/users/users_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/loader/main_loader.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/base_widgets/session/session_loader_builder.dart';
import 'package:smart_lunch/core/base_widgets/session/session_loader_listener.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/children/widget/child_card.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class ChildrenPage extends StatelessWidget {
  const ChildrenPage({super.key});

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
      child: SessionLoadingBuilder(
        builder: (context, loading) {
          // Cargar evento una sola vez
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<UsersBloc>().add(LoadFamilyChildrenEvent());
          });

          return SessionLoaderListener(
            shouldNavigate: false,
            loadOpepaySettings: false,
            onUnauthenticatedSession: () {},
            child: loading
                ? const MainLoader()
                : TransparentScaffold(
                    selectedOption: "Hijos",
                    body: BlocBuilder<UsersBloc, UsersState>(
                      builder: (context, state) {
                        return Stack(
                          children: [
                            Column(
                              children: [
                                CustomAppBar(
                                  height: 120,
                                  image: AppImages.cardImg,
                                  showPageTitle: true,
                                  pageTitle: AppLocalizations.of(
                                    context,
                                  )!.children,
                                  showDrawer: true,
                                  showSchoolLogo: false,
                                  hideGoBackText: false,
                                  titleAlignment: Alignment.bottomLeft,
                                  titleTopPadding: 0.4,
                                  titleSize: 32.0,
                                ),

                                if (state is FamilyChildrenLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),

                                if (state is FamilyChildrenLoaded)
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: state.familyChildren.length,
                                      itemBuilder: (context, index) {
                                        final child =
                                            state.familyChildren[index];
                                        return ChildCard(
                                          name:
                                              '${child.user?.firstName ?? ''} ${child.user?.lastName ?? ''}',
                                          matricula:
                                              child.user?.id?.toString() ??
                                              '0000',
                                          id:
                                              child.school?.toString() ??
                                              '0000',
                                          imageUrl: child.user?.picture,
                                          isActive: true,
                                          onTap: () {
                                            log(
                                              'ID cafeteria: ${child.id} - User name: ${child.user?.firstName} ${child.user?.lastName} -  ID User: ${child.user?.id}',
                                            );

                                            context
                                                .read<SelectedUserBloc>()
                                                .add(
                                                  SelectUser(
                                                    cafeteriaUserId: child.id!,
                                                  ),
                                                );

                                            context.push(AppRoutes.getChild);
                                          },
                                        );
                                      },
                                    ),
                                  ),

                                if (state is UsersLoaded &&
                                    state.familyChildren != null)
                                  Text(
                                    'Familiares: ${state.familyChildren!.length}',
                                  ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          );
        },
      ),
    );
  }
}
