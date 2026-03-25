import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/language/language_bloc.dart';
import 'package:smart_lunch/blocs/language/language_state.dart';
import 'package:smart_lunch/core/base_widgets/snackbar/app_snackbar.dart';
import 'package:smart_lunch/core/theme/theme.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/routes/app_router.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return MaterialApp.router(
              scaffoldMessengerKey: AppSnackbar.messengerKey,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: const [Locale('en'), Locale('es')],
              locale: state.locale,
              routerConfig: AppRouter.router,
              title: "Smart Lunch",
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
            );
          },
        );
      },
    );
  }
}
