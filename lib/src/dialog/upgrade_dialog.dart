import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upgrade_util/src/config/android_market.dart';
import 'package:upgrade_util/src/config/android_upgrade_config.dart';
import 'package:upgrade_util/src/config/enum.dart';
import 'package:upgrade_util/src/config/ios_upgrade_config.dart';
import 'package:upgrade_util/src/config/ui_upgrade_config.dart';
import 'package:upgrade_util/src/local/upgrade_localizations.dart';
import 'package:upgrade_util/src/upgrade_util.dart';

import 'cupertino_upgrade_dialog.dart';
import 'material_upgrade_dialog.dart';

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

  uiUpgradeConfig ??= UiUpgradeConfig(title: local.title);
  uiUpgradeConfig.updateText ??= local.updateText;
  uiUpgradeConfig.cancelText ??= local.cancelText;

  Widget child = _UpgradeDialog(
    key: key,
    uiUpgradeConfig: uiUpgradeConfig,
    iOSUpgradeConfig: iOSUpgradeConfig,
    androidUpgradeConfig: androidUpgradeConfig,
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

  if (Platform.isIOS && (iOSUpgradeConfig.appleId ?? '').isEmpty) {
    throw ArgumentError('On iOS, it cannot be used when `appleId` is empty.');
  }

  if (Platform.isAndroid &&
      (androidUpgradeConfig.packageName ?? '').isEmpty &&
      (androidUpgradeConfig.downloadUrl ?? '').isEmpty) {
    throw ArgumentError(
      'On Android, it cannot be used when `packageName` is empty and '
      '`downloadUrl` is empty.',
    );
  }
}

/// The widget of the upgrade dialog.
@protected
class _UpgradeDialog extends StatefulWidget {
  /// Externally provided
  const _UpgradeDialog({
    Key? key,
    required this.uiUpgradeConfig,
    required this.iOSUpgradeConfig,
    required this.androidUpgradeConfig,
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

  @override
  State<_UpgradeDialog> createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends State<_UpgradeDialog> {
  @override
  Widget build(BuildContext context) {
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
              'The upgrade_util plugin currently only supports Android and '
              'iOS.',
        );
    }
  }

  void _cancel() => Navigator.pop(context);

  Future<void> _update(String? marketPackageName) async {
    if (Platform.isAndroid && marketPackageName == null) {
      return;
    }

    Navigator.pop(context);
    await UpgradeUtil.jumpToStore(
      jumpMode: JumpMode.detailPage,
      appleId: widget.iOSUpgradeConfig.appleId,
      packageName: widget.androidUpgradeConfig.packageName,
      marketPackageName: marketPackageName,
    );
  }

  bool get force => uiUpgradeConfig.force;

  Widget get title => Text(
        uiUpgradeConfig.title ?? '',
        style: uiUpgradeConfig.titleTextStyle,
        strutStyle: uiUpgradeConfig.titleStrutStyle,
      );

  Widget? get content => uiUpgradeConfig.content != null
      ? Text(
          uiUpgradeConfig.content!,
          style: uiUpgradeConfig.contentTextStyle,
          strutStyle: uiUpgradeConfig.contentStrutStyle,
          textAlign: TextAlign.start,
        )
      : null;

  String get updateText => uiUpgradeConfig.updateText ?? '';

  String get cancelText => uiUpgradeConfig.cancelText ?? '';

  UiUpgradeConfig get uiUpgradeConfig => widget.uiUpgradeConfig;
}
