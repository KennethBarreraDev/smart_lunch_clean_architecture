import 'package:flutter/material.dart';
import 'package:smart_lunch/data/providers/secure_storage_provider.dart';

abstract class LanguageEvent {}

class LoadLanguage extends LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final Locale locale;

  ChangeLanguage(this.locale);
}