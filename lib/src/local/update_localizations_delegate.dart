import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'update_localizations.dart';

/// @Describe: LocalizationsDelegate
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/12

class UpdateLocalizationsDelegate
    extends LocalizationsDelegate<UpdateLocalizations> {
  const UpdateLocalizationsDelegate();

  static const UpdateLocalizationsDelegate delegate =
      UpdateLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      UpdateLocalizations.languages.contains(locale.languageCode);

  @override
  Future<UpdateLocalizations> load(Locale locale) {
    return SynchronousFuture<UpdateLocalizations>(UpdateLocalizations(locale));
  }

  @override
  bool shouldReload(UpdateLocalizationsDelegate old) => false;
}
