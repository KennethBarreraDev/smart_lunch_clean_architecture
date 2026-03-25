import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/data/repositories/language/language_repository.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {

  final LanguageRepository repository;

  final supportedLocales = ['en', 'es'];

  LanguageBloc(this.repository)
      : super(const LanguageState(locale: Locale('en'))) {

    on<LoadLanguage>(_loadLanguage);
    on<ChangeLanguage>(_changeLanguage);
  }

  Future<void> _loadLanguage(
    LoadLanguage event,
    Emitter<LanguageState> emit,
  ) async {

    final languageCode = await repository.getSavedLanguage();

    if (languageCode != null && languageCode.isNotEmpty) {
      emit(state.copyWith(locale: Locale(languageCode)));
      return;
    }

    final deviceLocale =
        WidgetsBinding.instance.platformDispatcher.locales.first;

    if (supportedLocales.contains(deviceLocale.languageCode)) {
      emit(state.copyWith(locale: Locale(deviceLocale.languageCode)));
    } else {
      emit(state.copyWith(locale: const Locale('en')));
    }
  }

  Future<void> _changeLanguage(
    ChangeLanguage event,
    Emitter<LanguageState> emit,
  ) async {

    await repository.saveLanguage(event.locale.languageCode);

    emit(state.copyWith(locale: event.locale));
  }
}