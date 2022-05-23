import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'upgrade_localizations.dart';

/// @Describe: LocalizationsDelegate
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/12

class UpgradeLocalizationsDelegate
    extends LocalizationsDelegate<UpgradeLocalizations> {
  const UpgradeLocalizationsDelegate();

  static const UpgradeLocalizationsDelegate delegate =
      UpgradeLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      UpgradeLocalizations.languages.contains(locale.languageCode);

  @override
  Future<UpgradeLocalizations> load(Locale locale) {
    return SynchronousFuture<UpgradeLocalizations>(
      UpgradeLocalizations(locale),
    );
  }

  @override
  bool shouldReload(UpgradeLocalizationsDelegate old) => false;
}
