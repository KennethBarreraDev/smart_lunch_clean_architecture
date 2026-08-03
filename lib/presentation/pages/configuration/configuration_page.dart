import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/loader/main_loader.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

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
      child: false
          ? MainLoader()
          : TransparentScaffold(
              selectedOption: "Ajustes",
              body: Stack(
                children: [
                  Column(
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

                      Text('Estas en el ajustes'),

                      // Mas codigo
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
