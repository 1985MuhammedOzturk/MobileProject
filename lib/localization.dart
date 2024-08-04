import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///A class for the localization of the app
class AppLocalizations {
  ///The locale for the current instance
  final Locale locale;

  ///creates an instance for the given locale
  AppLocalizations(this.locale);
///retrieves the Applocalizations instance
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
///a amp containing the localized strings.
  late Map<String, String> _localizedStrings;
///loads the localized texts for the current locale
  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }
///retrieves the localized text
  String translate(String key) {
    return _localizedStrings[key] ?? 'Translation not found';
  }
}
/// this class responsible for loading the localized strings.
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  ///creates an instance for _AppLocalizationsDelegate
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
