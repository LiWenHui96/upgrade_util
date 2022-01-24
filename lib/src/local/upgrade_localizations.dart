import 'package:flutter/material.dart';

/// @Describe: Localizations
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/12

abstract class UpgradeLocalizationsBase {
  const UpgradeLocalizationsBase(this.locale);

  final Locale? locale;

  Object? getItem(String key);

  String get title => getItem('title').toString();

  String get content => getItem('content').toString();

  String get cancelText => getItem('cancelText').toString();

  String get updateText => getItem('updateText').toString();

  String get androidTitle => getItem('androidTitle').toString();

  String get androidCencel => getItem('androidCencel').toString();

  String get downloadTip => getItem('downloadTip').toString();
}

/// localizations
class UpgradeLocalizations extends UpgradeLocalizationsBase {
  const UpgradeLocalizations(Locale? locale) : super(locale);

  static const UpgradeLocalizations _static = UpgradeLocalizations(null);

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

  static UpgradeLocalizations of(BuildContext context) {
    return Localizations.of<UpgradeLocalizations>(
            context, UpgradeLocalizations) ??
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
      'androidTitle': 'Complete action using',
      'androidCencel': 'Cancel',
      'downloadTip': 'Downloading:',
    },
    'zh': {
      'title': '发现新版本',
      'content': '新功能已上线，立即更新',
      'cancelText': '以后再说',
      'updateText': '立即体验',
      'androidTitle': '选择要使用的应用',
      'androidCencel': '取消',
      'downloadTip': '正在下载：',
    },
  };
}