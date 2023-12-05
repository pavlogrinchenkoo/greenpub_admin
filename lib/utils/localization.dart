import 'package:delivery/api/localization/dto.dart';
import 'package:delivery/api/localization/request.dart';
import 'package:delivery/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  final _LanguagePrefs _prefs = _LanguagePrefs();
  Locale? _locale;
  Localization localization = Localization('en');

  LanguageService() {
    localization.get().then((value) => notifyListeners());
    _prefs.getLanguage().then((language) {
      _applyLocaleAndNotify(language != null ? Locale(language) : null);
    });
  }

  Future<void> _applyLocaleAndNotify(Locale? value) async {
    if (_locale != value) {
      _locale = value;
      notifyListeners();
    }
  }

  Locale? get customLocale => _locale;

  Locale get locale => customLocale ?? appLocale();

  LocalizationModel get s => localization.s;

  Future<void> setLanguage(String language) => _prefs
      .setLanguage(language)
      .then((_) => _applyLocaleAndNotify(Locale(language)));
}

class _LanguagePrefs {
  static const keyLanguage = "keyLanguagePrefs";

  Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  Future<void> setLanguage(String language) =>
      _prefs().then((prefs) => prefs.setString(keyLanguage, language));

  Future<String?> getLanguage() =>
      _prefs().then((prefs) => prefs.getString(keyLanguage));
}

class Localization {
  Localization(this.stringLocale);

  String stringLocale;
  LocalizationModel s = LocalizationModel();
  final LocalizationRequest request = LocalizationRequest();

  Future<LocalizationModel> get() async {
    final LocalizationModel local = await request.get(stringLocale);
    s = local;
    return s;
  }
}
