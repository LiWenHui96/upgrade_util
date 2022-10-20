import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'android_market.dart';
import 'dialog/material_upgrade_dialog.dart';

/// @Describe: Upgrade Config
///
/// @Author: LiWeNHuI
/// @Date: 2022/5/27

class UpgradeConfig {
  // ignore: public_member_api_docs
  UpgradeConfig({
    this.force = false,
    this.titleWidget,
    this.title,
    this.titleTextStyle,
    this.titleStrutStyle,
    this.contentWidget,
    this.content,
    this.contentTextStyle,
    this.contentStrutStyle,
    this.updateText,
    this.updateTextStyle,
    this.cancelText,
    this.cancelTextStyle,
  });

  /// Whether to force the update, there is no cancel button
  /// when forced.
  ///
  /// It is `false` by default.
  final bool force;

  /// The layout of the title. When it is empty, use [Text] instead.
  final Widget? titleWidget;

  /// A title of the version.
  late String? title;

  /// The text style of [title].
  final TextStyle? titleTextStyle;

  /// The strut style of [title].
  final StrutStyle? titleStrutStyle;

  /// The layout of the description. When it is empty, use [Text] instead.
  final Widget? contentWidget;

  /// A description of the version.
  late String? content;

  /// The text style of [content].
  final TextStyle? contentTextStyle;

  /// The strut style of [content].
  final StrutStyle? contentStrutStyle;

  /// Text message of the update button.
  late String? updateText;

  /// The text style of [updateText].
  final TextStyle? updateTextStyle;

  /// Text message of cancel button.
  late String? cancelText;

  /// The text style of [cancelText].
  final TextStyle? cancelTextStyle;
}

/// iOS Upgrade Config
class IosUpgradeConfig {
  // ignore: public_member_api_docs
  IosUpgradeConfig({
    this.appleId,
    this.scrollController,
    this.actionScrollController,
    this.isUpgradeDefaultAction = false,
    this.isUpgradeDestructiveAction = false,
    this.isCancelDefaultAction = false,
    this.isCancelDestructiveAction = true,
  });

  /// Apple ID.
  ///
  /// It is required.
  final String? appleId;

  /// A scroll controller that can be used to control the scrolling of the
  /// `content` in the dialog.
  ///
  /// Defaults to null, and is typically not needed, since most alert messages
  /// are short.
  ///
  /// See also:
  ///
  ///  * [actionScrollController], which can be used for controlling the actions
  ///    section when there are many actions.
  final ScrollController? scrollController;

  /// A scroll controller that can be used to control the scrolling of the
  /// actions in the dialog.
  ///
  /// Defaults to null, and is typically not needed.
  ///
  /// See also:
  ///
  ///  * [scrollController], which can be used for controlling the `content`
  ///    section when it is long.
  final ScrollController? actionScrollController;

  /// Set to true if button is the default choice in the dialog.
  ///
  /// It is applied to Updates button.
  final bool isUpgradeDefaultAction;

  /// Whether this action destroys an object.
  ///
  /// It is applied to Updates button.
  final bool isUpgradeDestructiveAction;

  /// Set to true if button is the default choice in the dialog.
  ///
  /// It is applied to Cancel button.
  final bool isCancelDefaultAction;

  /// Whether this action destroys an object.
  ///
  /// It is applied to Cancel button.
  final bool isCancelDestructiveAction;
}

/// Android Upgrade Config
class AndroidUpgradeConfig {
  // ignore: public_member_api_docs
  AndroidUpgradeConfig({
    this.androidMarket,
    this.otherMarkets = const <String>[],
    this.dialogBorderRadius,
    this.topImageProvider,
    this.topImageHeight,
    this.updateButtonStyle,
    this.downloadCancelText,
    this.downloadUri,
    this.saveName,
    this.downloadInterceptors = const <Interceptor>[],
    this.deleteOnError = true,
    this.lengthHeader = Headers.contentLengthHeader,
    this.data,
    this.options,
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

  /// The settings of app market for Android.
  final AndroidMarket? androidMarket;

  /// The package name for markets other than presets.
  final List<String> otherMarkets;

  /// The dialog's borderRadius.
  final BorderRadius? dialogBorderRadius;

  /// Picture at the top of the dialog.
  final ImageProvider? topImageProvider;

  /// Height of the image.
  final double? topImageHeight;

  /// The style of the upgrade button.
  final ButtonStyle? updateButtonStyle;

  /// Cancel text when downloading
  late String? downloadCancelText;

  /// A link of download for Apk.
  final Uri? downloadUri;

  /// A link of download for Apk.
  @Deprecated('Use downloadUri instead')
  String? downloadUrl;

  /// The name of the file after the apk download is completed.
  final String? saveName;

  /// Interceptors added to [Dio].
  final List<Interceptor> downloadInterceptors;

  /// Whether delete the file when error occurs. The default value is true.
  final bool deleteOnError;

  ///  The real size of original file (not compressed).
  ///  When file is compressed:
  ///  1. If this value is 'content-length', the `total` argument of
  ///  `onProgress` will be -1
  ///  2. If this value is not 'content-length', maybe a custom header
  ///  indicates the original file size , the `total` argument of `onProgress`
  ///  will be this header value.
  final String lengthHeader;

  /// The request data.
  final dynamic data;

  /// Every request can pass a [Options] object.
  final Options? options;

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

  /// All application markets before screening.
  AndroidMarket get androidMarkets => androidMarket ?? AndroidMarket();

  /// Package names of all application markets before screening.
  List<String> get marketPackageNames =>
      androidMarkets.toMarkets()..addAll(otherMarkets);
}

/// Listener - Download progress
typedef DownloadProgressCallback = Function(int count, int total);

/// Listener - Download status
typedef DownloadStatusCallback = Function(
  DownloadStatus status, {
  dynamic error,
});
