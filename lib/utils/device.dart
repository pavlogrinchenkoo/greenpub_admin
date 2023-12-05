import 'dart:io';

import 'package:delivery/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Locale appLocale() {
  if (kIsWeb) {
    return const Locale('en'); // TODO: Get from browser
  } else {
    final systemLangCode = Platform.localeName.split('_').first;
    final locale = S.delegate.supportedLocales
        .firstWhere(
            (it) => it.languageCode == systemLangCode,
        orElse: () => const Locale('en'));
    return locale;
  }
}
