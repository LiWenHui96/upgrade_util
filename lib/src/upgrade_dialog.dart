import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dialog/cupertino_upgrade_dialog.dart';
import 'dialog/material_upgrade_dialog.dart';
import 'upgrade_config.dart';
import 'upgrade_localizations.dart';
import 'upgrade_util.dart';

/// @Describe: Upgrade Dialog
///
/// @Author: LiWeNHuI
/// @Date: 2022/5/26

Future<T?> showUpgradeDialog<T>(
  BuildContext context, {
  Key? key,
  UpgradeConfig? upgradeConfig,
  IosUpgradeConfig? iOSUpgradeConfig,
  AndroidUpgradeConfig? androidUpgradeConfig,
  bool isDebugLog = false,
  String? barrierLabel,
}) {
  _platformAssert(
    iOSUpgradeConfig: iOSUpgradeConfig ??= IosUpgradeConfig(),
    androidUpgradeConfig: androidUpgradeConfig ??= AndroidUpgradeConfig(),
  );

  final UpgradeLocalizations local = UpgradeLocalizations.of(context);
  const RouteSettings routeSettings = RouteSettings(name: '/UpgradeDialog');

  androidUpgradeConfig.downloadCancelText ??= local.androidCancel;

  upgradeConfig ??= UpgradeConfig(title: local.title);
  upgradeConfig.updateText ??= local.updateText;
  upgradeConfig.cancelText ??= local.cancelText;

  Widget child = _UpgradeDialog(
    key: key,
    upgradeConfig: upgradeConfig,
    iOSUpgradeConfig: iOSUpgradeConfig,
    androidUpgradeConfig: androidUpgradeConfig,
    isDebugLog: isDebugLog,
  );

  child = WillPopScope(child: child, onWillPop: () async => false);

  if (defaultTargetPlatform == TargetPlatform.android) {
    return showMaterialUpgradeDialog(
      context,
      child: child,
      barrierColor: const Color.fromRGBO(0, 0, 0, .4),
      barrierLabel: barrierLabel,
      routeSettings: routeSettings,
    );
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return showCupertinoUpgradeDialog(
      context,
      child: child,
      barrierLabel: barrierLabel,
      routeSettings: routeSettings,
    );
  } else {
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
  if (!(defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android)) {
    throw PlatformException(
      code: 'Unimplemented',
      details:
          'The upgrade_util plugin currently only supports Android and iOS.',
    );
  }

  if (defaultTargetPlatform == TargetPlatform.iOS &&
      (iOSUpgradeConfig.appleId ?? '').isEmpty) {
    throw ArgumentError('On iOS, it cannot be used when `appleId` is empty.');
  }

  if (defaultTargetPlatform == TargetPlatform.android &&
      androidUpgradeConfig.marketPackageNames.isEmpty &&
      androidUpgradeConfig.downloadUri == null) {
    throw ArgumentError(
      'On Android, it cannot be used when markets is empty and '
      '`downloadUri` is empty.',
    );
  }
}

/// The widget of the upgrade dialog.
@protected
class _UpgradeDialog extends StatefulWidget {
  const _UpgradeDialog({
    Key? key,
    required this.upgradeConfig,
    required this.iOSUpgradeConfig,
    required this.androidUpgradeConfig,
    required this.isDebugLog,
  }) : super(key: key);

  /// ui upgrade config.
  ///
  /// It is required.
  final UpgradeConfig upgradeConfig;

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

  final bool isDebugLog;

  @override
  State<_UpgradeDialog> createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends State<_UpgradeDialog> {
  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return MaterialUpgradeDialog(
          androidUpgradeConfig: widget.androidUpgradeConfig,
          force: force,
          title: title,
          content: content,
          updateText: updateText,
          updateTextStyle: upgradeConfig.updateTextStyle,
          cancelText: cancelText,
          cancelTextStyle: upgradeConfig.cancelTextStyle,
          onUpgradePressed: _update,
          onCancelPressed: _cancel,
          isDebugLog: widget.isDebugLog,
        );
      case TargetPlatform.iOS:
        return CupertinoUpgradeDialog(
          iOSUpgradeConfig: widget.iOSUpgradeConfig,
          force: force,
          title: title,
          content: content,
          updateText: updateText,
          updateTextStyle: upgradeConfig.updateTextStyle,
          cancelText: cancelText,
          cancelTextStyle: upgradeConfig.cancelTextStyle,
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
    if (defaultTargetPlatform == TargetPlatform.android &&
        marketPackageName == null) {
      return;
    }

    if (!force) {
      Navigator.pop(context);
    }

    await UpgradeUtil.jumpToStore(
      jumpMode: JumpMode.detailPage,
      appleId: widget.iOSUpgradeConfig.appleId,
      marketPackageName: marketPackageName,
    );
  }

  bool get force => upgradeConfig.force;

  Widget get title =>
      upgradeConfig.titleWidget ??
      Text(
        upgradeConfig.title ?? '',
        style: upgradeConfig.titleTextStyle,
        strutStyle: upgradeConfig.titleStrutStyle,
      );

  Widget? get content =>
      upgradeConfig.contentWidget ??
      (upgradeConfig.content != null
          ? Text(
              upgradeConfig.content!,
              style: upgradeConfig.contentTextStyle,
              strutStyle: upgradeConfig.contentStrutStyle,
              textAlign: TextAlign.start,
            )
          : null);

  String get updateText => upgradeConfig.updateText ?? '';

  String get cancelText => upgradeConfig.cancelText ?? '';

  UpgradeConfig get upgradeConfig => widget.upgradeConfig;
}
