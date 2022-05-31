import 'package:flutter/material.dart';

import 'android_market.dart';
import 'enum.dart';

/// @Describe: Android Upgrade Config
///
/// @Author: LiWeNHuI
/// @Date: 2022/5/27

class AndroidUpgradeConfig {
  /// Externally provided
  AndroidUpgradeConfig({
    this.packageName,
    this.androidMarket,
    this.otherMarkets,
    this.downloadUrl,
    this.saveName,
    this.downloadCancelText,
    this.indicatorBackgroundColor,
    this.indicatorColor,
    this.indicatorValueColor,
    this.indicatorTextColor,
    this.onDownloadProgressCallback,
    this.onDownloadStatusCallback,
  });

  /// The name of package.
  final String? packageName;

  /// The settings of app market for Android.
  late AndroidMarket? androidMarket;

  /// The package name for markets other than presets.
  final List<String>? otherMarkets;

  /// A link of download for Apk.
  final String? downloadUrl;

  /// The name of the file after the apk download is completed.
  final String? saveName;

  /// Cancel text when downloading
  late String? downloadCancelText;

  /// It is [LinearProgressIndicator.backgroundColor].
  final Color? indicatorBackgroundColor;

  /// It is `LinearProgressIndicator.color`.
  final Color? indicatorColor;

  /// It is `LinearProgressIndicator.valueColor`.
  final Animation<Color?>? indicatorValueColor;

  /// The text color of the indicator.
  ///
  /// It is [Colors.white] by default.
  final Color? indicatorTextColor;

  /// Realize the listening event of download progress.
  final DownloadProgressCallback? onDownloadProgressCallback;

  /// Realize the listening event of download status.
  final DownloadStatusCallback? onDownloadStatusCallback;
}

/// Listener - Download progress
typedef DownloadProgressCallback = Function(int count, int total);

/// Listener - Download status
typedef DownloadStatusCallback = Function(
  DownloadStatus status, {
  dynamic error,
});
