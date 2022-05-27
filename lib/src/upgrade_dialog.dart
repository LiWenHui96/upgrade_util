import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upgrade_util/src/config/ui_upgrade_config.dart';

import 'config/android_market.dart';
import 'config/android_upgrade_config.dart';
import 'config/download_status.dart';
import 'config/ios_upgrade_config.dart';
import 'dialog/cupertino_upgrade_dialog.dart';
import 'dialog/material_upgrade_dialog.dart';
import 'local/upgrade_localizations.dart';

/// @Describe: Upgrade Dialog
///
/// @Author: LiWeNHuI
/// @Date: 2022/5/26

Future<T?> showUpgradeDialog<T>(
  BuildContext context, {
  Key? key,
  UiUpgradeConfig? uiUpgradeConfig,
  IosUpgradeConfig? iOSUpgradeConfig,
  AndroidUpgradeConfig? androidUpgradeConfig,
  VoidCallback? updateCallback,
  VoidCallback? cancelCallback,
  DownloadProgressCallback? downloadProgressCallback,
  DownloadStatusCallback? downloadStatusCallback,
  String? barrierLabel,
  Object? arguments,
}) {
  _platformAssert(
    iOSUpgradeConfig: iOSUpgradeConfig ??= IosUpgradeConfig(),
    androidUpgradeConfig: androidUpgradeConfig ??= AndroidUpgradeConfig(),
  );

  final UpgradeLocalizations local = UpgradeLocalizations.of(context);
  final RouteSettings routeSettings =
      RouteSettings(name: '/UpgradeDialog', arguments: arguments);

  androidUpgradeConfig.androidMarket ??= AndroidMarket();
  androidUpgradeConfig.downloadCancelText ??= local.androidCancel;

  uiUpgradeConfig ??= UiUpgradeConfig();
  uiUpgradeConfig.title ??= local.title;
  uiUpgradeConfig.content ??= local.content;
  uiUpgradeConfig.updateText ??= local.updateText;
  uiUpgradeConfig.cancelText ??= local.cancelText;

  Widget child = UpgradeDialog(
    key: key,
    uiUpgradeConfig: uiUpgradeConfig,
    iOSUpgradeConfig: iOSUpgradeConfig,
    androidUpgradeConfig: androidUpgradeConfig,
    updateCallback: updateCallback,
    cancelCallback: cancelCallback,
    downloadProgressCallback: downloadProgressCallback,
    downloadStatusCallback: downloadStatusCallback,
  );

  child = WillPopScope(child: child, onWillPop: () async => false);

  switch (Theme.of(context).platform) {
    case TargetPlatform.android:
      return showMaterialUpgradeDialog(
        context,
        child: child,
        barrierColor: const Color.fromRGBO(0, 0, 0, .4),
        barrierLabel: barrierLabel,
        routeSettings: routeSettings,
      );
    case TargetPlatform.iOS:
      return showCupertinoUpgradeDialog(
        context,
        child: child,
        barrierLabel: barrierLabel,
        routeSettings: routeSettings,
      );
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
      throw PlatformException(
        code: 'Unimplemented',
        details:
            'The upgrade_util plugin currently only supports Android and iOS.',
      );
  }
}

/// Data analysis
void _platformAssert({
  required IosUpgradeConfig iOSUpgradeConfig,
  required AndroidUpgradeConfig androidUpgradeConfig,
}) {
  if (!(Platform.isIOS || Platform.isAndroid)) {
    throw PlatformException(
      code: 'Unimplemented',
      details:
          'The upgrade_util plugin currently only supports Android and iOS.',
    );
  }

  if (Platform.isIOS && iOSUpgradeConfig.appleId == null) {
    throw ArgumentError('On iOS, it cannot be used when `appleId` is empty.');
  }

  if (Platform.isAndroid &&
      androidUpgradeConfig.packageName == null &&
      androidUpgradeConfig.downloadUrl == null) {
    throw ArgumentError(
        'On Android, it cannot be used when `androidUpgradeConfig` is empty.');
  }
}

/// The widget of the upgrade dialog.
@protected
class UpgradeDialog extends StatefulWidget {
  /// Externally provided
  const UpgradeDialog({
    Key? key,
    required this.uiUpgradeConfig,
    required this.iOSUpgradeConfig,
    required this.androidUpgradeConfig,
    this.updateCallback,
    this.cancelCallback,
    this.downloadProgressCallback,
    this.downloadStatusCallback,
  }) : super(key: key);

  /// ui upgrade config.
  ///
  /// It is required.
  final UiUpgradeConfig uiUpgradeConfig;

  /// iOS upgrade config.
  /// Only iOS is supported.
  ///
  /// It is required.
  final IosUpgradeConfig iOSUpgradeConfig;

  /// Android upgrade config.
  /// Only Android is supported.
  ///
  /// It is required.
  final AndroidUpgradeConfig androidUpgradeConfig;

  /// Implement the event listener of clicking the update button.
  final VoidCallback? updateCallback;

  /// Implement the event listener of clicking the cancel button.
  final VoidCallback? cancelCallback;

  /// Realize the listening event of download progress.
  final DownloadProgressCallback? downloadProgressCallback;

  /// Realize the listening event of download status.
  final DownloadStatusCallback? downloadStatusCallback;

  @override
  State<UpgradeDialog> createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends State<UpgradeDialog> {
  /// Whether to show `CupertinoActivityIndicator`.
  bool _isShowIndicator = false;

  /// Download progress
  double _downloadProgress = .1;

  /// Download status
  DownloadStatus _downloadStatus = DownloadStatus.none;

  final CancelToken _cancelToken = CancelToken();

  @override
  void dispose() {
    super.dispose();

    _cancelToken.cancel('Upgrade Dialog is closed.');
  }

  @override
  Widget build(BuildContext context) {
    print(uiUpgradeConfig.updateText);
    print(uiUpgradeConfig.cancelText);

    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        return MaterialUpgradeDialog(
          androidUpgradeConfig: widget.androidUpgradeConfig,
          force: force,
          title: title,
          content: content,
          updateText: updateText,
          updateTextStyle: uiUpgradeConfig.updateTextStyle,
          cancelText: cancelText,
          cancelTextStyle: uiUpgradeConfig.cancelTextStyle,
          isShowIndicator: _isShowIndicator,
          downloadProgress: _downloadProgress,
          onUpgradePressed: _update,
          onCancelPressed: _cancel,
        );
      case TargetPlatform.iOS:
        return CupertinoUpgradeDialog(
          iOSUpgradeConfig: widget.iOSUpgradeConfig,
          force: force,
          title: title,
          content: content,
          updateText: updateText,
          updateTextStyle: uiUpgradeConfig.updateTextStyle,
          cancelText: cancelText,
          cancelTextStyle: uiUpgradeConfig.cancelTextStyle,
          onUpgradePressed: _update,
          onCancelPressed: _cancel,
        );
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'The upgrade_util plugin currently only supports Android and iOS.',
        );
    }
  }

  void _cancel() {
    widget.cancelCallback?.call();

    Navigator.pop(context);
  }

  Future<void> _update() async {}

  bool get force => uiUpgradeConfig.force;

  Widget get title => Text(
        uiUpgradeConfig.title ?? '',
        style: uiUpgradeConfig.titleTextStyle,
        strutStyle: uiUpgradeConfig.titleStrutStyle,
      );

  Widget get content => Text(
        uiUpgradeConfig.content ?? '',
        style: uiUpgradeConfig.contentTextStyle,
        strutStyle: uiUpgradeConfig.contentStrutStyle,
        textAlign: TextAlign.start,
      );

  String get updateText => uiUpgradeConfig.updateText ?? '';

  String get cancelText => uiUpgradeConfig.cancelText ?? '';

  UiUpgradeConfig get uiUpgradeConfig => widget.uiUpgradeConfig;
}

/// Listener - Download progress
typedef DownloadProgressCallback = Function(int count, int total);

/// Listener - Download status
typedef DownloadStatusCallback = Function(
  DownloadStatus status, {
  dynamic error,
});
