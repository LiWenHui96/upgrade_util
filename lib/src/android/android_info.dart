import 'package:flutter/material.dart';

import 'android_market.dart';

/// @Describe: Android Upgrade Info
///
/// @Author: LiWeNHuI
/// @Date: 2022/3/11

class AndroidUpgradeInfo {
  AndroidUpgradeInfo({
    @required this.packageName,
    this.androidMarket,
    this.otherMarkets,
    this.downloadUrl,
    this.saveApkName,
    this.savePrefixName,
  });

  /// The [packageName] is the package name.
  final String packageName;

  /// The [androidMarket] is the settings of app market for Android.
  ///
  /// It is all false by default.
  final AndroidMarket androidMarket;

  /// Package name for markets other than presets.
  final List<String> otherMarkets;

  /// The [downloadUrl] is a link of download for Apk.
  final String downloadUrl;

  /// They are the saved information after the apk download is completed. For details, see the [UpgradeUtil.getDownloadPath] method.
  final String saveApkName;
  final String savePrefixName;
}
