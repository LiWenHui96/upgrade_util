import 'package:flutter/material.dart';

/// @Describe: Localizations
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/12

abstract class UpdateLocalizationsBase {
  const UpdateLocalizationsBase(this.locale);

  final Locale? locale;

  Object? getItem(String key);

  String get title => getItem('title').toString();

  String get content => getItem('content').toString();

  String get cancelText => getItem('cancelText').toString();

  String get updateText => getItem('updateText').toString();
}

/// localizations
class UpdateLocalizations extends UpdateLocalizationsBase {
  const UpdateLocalizations(Locale? locale) : super(locale);

  static const UpdateLocalizations _static = UpdateLocalizations(null);

  @override
  Object? getItem(String key) {
    Map? localData;
    if (locale != null) {
      localData = localizedValues[locale!.languageCode];
    }
    if (localData == null) {
      return localizedValues['zh']![key];
    }
    return localData[key];
  }

  static UpdateLocalizations of(BuildContext context) {
    return Localizations.of<UpdateLocalizations>(
            context, UpdateLocalizations) ??
        _static;
  }

  /// Language Support
  static const List<String> languages = ['en', 'zh'];

  /// Language Values
  static const Map<String, Map<String, Object>> localizedValues = {
    'en': {
      'title': 'Discover new versions',
      'content': 'New features are live, update now.',
      'cancelText': 'Not Updated',
      'updateText': 'Update Now',
    },
    'zh': {
      'title': '发现新版本',
      'content': '新功能已上线，立即更新',
      'cancelText': '暂不更新',
      'updateText': '立即更新',
    },
  };
}
