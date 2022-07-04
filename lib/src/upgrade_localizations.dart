import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// @Describe: LocalizationsDelegate
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/12

class UpgradeLocalizationsDelegate
    extends LocalizationsDelegate<UpgradeLocalizations> {
  // ignore: public_member_api_docs
  const UpgradeLocalizationsDelegate();

  /// Provided to [MaterialApp] for use.
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

/// Localizations
abstract class UpgradeLocalizationsBase {
  // ignore: public_member_api_docs
  const UpgradeLocalizationsBase(this.locale);

  // ignore: public_member_api_docs
  final Locale? locale;

  // ignore: public_member_api_docs
  Object? getItem(String key);

  /// Default Title
  String get title => getItem('title').toString();

  /// Text of default cancel button
  String get cancelText => getItem('cancelText').toString();

  /// Text of the default upgrade button
  String get updateText => getItem('updateText').toString();

  ///
  String get androidCancel => getItem('androidCancel').toString();

  ///
  String get androidTitle => getItem('androidTitle').toString();
}

/// localizations
class UpgradeLocalizations extends UpgradeLocalizationsBase {
  // ignore: public_member_api_docs
  const UpgradeLocalizations(Locale? locale) : super(locale);

  static const UpgradeLocalizations _static = UpgradeLocalizations(null);

  @override
  Object? getItem(String key) {
    Map<String, Object>? localData;
    if (locale != null) {
      localData = localizedValues[locale!.languageCode];
    }
    if (localData == null) {
      return localizedValues['zh']![key];
    }
    return localData[key];
  }

  /// Internally available
  static UpgradeLocalizations of(BuildContext context) {
    return Localizations.of<UpgradeLocalizations>(
          context,
          UpgradeLocalizations,
        ) ??
        _static;
  }

  /// Language Support
  static const List<String> languages = <String>['en', 'zh'];

  /// Language Values
  static const Map<String, Map<String, Object>> localizedValues =
      <String, Map<String, Object>>{
    'en': <String, String>{
      'title': 'Discover new versions',
      'cancelText': 'Not Updated',
      'updateText': 'Update Now',
      'androidCancel': 'Cancel',
      'androidTitle': 'Complete action using',
    },
    'zh': <String, String>{
      'title': '发现新版本',
      'cancelText': '以后再说',
      'updateText': '立即体验',
      'androidCancel': '取消',
      'androidTitle': '选择要使用的应用',
    },
  };
}
