import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/language/language_bloc.dart';
import 'package:smart_lunch/blocs/language/language_event.dart';
import 'package:smart_lunch/blocs/language/language_state.dart';
import 'package:smart_lunch/core/base_widgets/selector/orange_selector.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/configuration/widgets/settings_option_card.dart';

class LanguageCard extends StatelessWidget {
  const LanguageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return SettingsOptionCard(
          icon: Icons.language,
          text: AppLocalizations.of(context)!.languaje_message,
          trailing: OrangeSelector<String>(
            ancho: 130,
            alto: 38,
            etiquetas: [
              AppLocalizations.of(context)!.language_spanish,
              AppLocalizations.of(context)!.language_english,
            ],
            valores: const ["es", "en"],
            valor: state.locale.languageCode,
            onChanged: (value) {
              context.read<LanguageBloc>().add(ChangeLanguage(Locale(value)));
            },
          ),
        );
      },
    );
  }
}
