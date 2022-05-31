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
    this.updateButtonStyle,
    this.downloadCancelText,
    this.isExistsFile = false,
    this.indicatorHeight,
    this.indicatorBackgroundColor,
    this.indicatorColor,
    this.indicatorValueColor,
    this.indicatorTextSize,
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

  /// The style of the upgrade button.
  final ButtonStyle? updateButtonStyle;

  /// Cancel text when downloading
  late String? downloadCancelText;

  /// Verify the existence of the file named [saveName].
  ///
  /// When the file exists, this is true, then go to installation,
  /// otherwise delete the file and download it.
  final bool isExistsFile;

  /// The height of the indicator.
  ///
  /// It is 10px by default.
  final double? indicatorHeight;

  /// It is [LinearProgressIndicator.backgroundColor].
  final Color? indicatorBackgroundColor;

  /// It is `LinearProgressIndicator.color`.
  final Color? indicatorColor;

  /// It is `LinearProgressIndicator.valueColor`.
  final Animation<Color?>? indicatorValueColor;

  /// The text size of the indicator.
  ///
  /// It is 8px by default.
  final double? indicatorTextSize;

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
