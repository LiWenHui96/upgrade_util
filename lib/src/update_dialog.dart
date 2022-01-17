import 'package:flutter/cupertino.dart';
import 'package:upgrade_util/upgrade_util.dart';

/// @Describe: Upgrade dialog
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/12

/// Listener
typedef UpdateCallback = Function(BuildContext context);

class UpdateDialog<T> {
  UpdateDialog(
    this.context, {
    required this.appKey,
    this.title,
    this.content,
    this.contentTextAlign = TextAlign.start,
    this.scrollController,
    this.actionScrollController,
    this.force = false,
    this.updateKey,
    this.updateText,
    this.updateTextStyle,
    this.isUpdateDefaultAction = false,
    this.isUpdateDestructiveAction = false,
    this.cancelKey,
    this.cancelText,
    this.cancelTextStyle,
    this.isCancelDefaultAction = false,
    this.isCancelDestructiveAction = true,
    this.updateCallback,
    this.cancelCallback,
  });

  Future<T?> show() async {
    assert(appKey != null && appKey.isNotEmpty);

    final local = UpdateLocalizations.of(context);

    return showCupertinoDialog<T>(
      context: context,
      builder: (ctx) {
        final cancelAction = CupertinoDialogAction(
          key: cancelKey,
          onPressed: () async =>
              cancelCallback?.call(ctx) ?? Navigator.pop(ctx),
          isDestructiveAction: isCancelDestructiveAction,
          isDefaultAction: isCancelDefaultAction,
          textStyle: cancelTextStyle,
          child: Text(cancelText ?? local.cancelText),
        );

        final updateAction = CupertinoDialogAction(
          key: updateKey,
          onPressed: () async => updateCallback?.call(ctx) ?? _update(ctx),
          isDefaultAction: force ? force : isUpdateDefaultAction,
          isDestructiveAction: isUpdateDestructiveAction,
          textStyle: updateTextStyle,
          child: Text(updateText ?? local.updateText),
        );

        final actions = <Widget>[if (!force) cancelAction, updateAction];

        return CupertinoAlertDialog(
          title: Text(title ?? local.title),
          content: Text(content ?? local.content, textAlign: contentTextAlign),
          scrollController: scrollController,
          actionScrollController: actionScrollController,
          actions: actions,
        );
      },
    );
  }

  /// The default update scheme, which can be replaced with `updateCallback`.
  Future _update(BuildContext context) async {
    Navigator.pop(context);
    await UpgradeUtil.upgradeApp(appKey: appKey);
  }

  final BuildContext context;

  /// On Android platform, The [appKey] is the package name.
  /// On iOS platform, The [appKey] is App Store ID.
  /// It is required.
  final String appKey;

  final String? title;

  final String? content;

  /// The [contentTextAlign] is how to align text horizontally of [content].
  /// It is `TextAlign.start` by default.
  final TextAlign contentTextAlign;

  final ScrollController? scrollController;
  final ScrollController? actionScrollController;

  /// The [force] is Whether to force the update, there is no cancel button when forced.
  /// It is `false` by default.
  final bool force;

  final Key? updateKey;
  final String? updateText;
  final TextStyle? updateTextStyle;
  final bool isUpdateDefaultAction;
  final bool isUpdateDestructiveAction;
  final Key? cancelKey;
  final String? cancelText;
  final TextStyle? cancelTextStyle;
  final bool isCancelDefaultAction;
  final bool isCancelDestructiveAction;

  /// Use [updateCallback] to implement the event listener of clicking the update button.
  /// It is to close the dialog and open App Store and then jump to the details page of the app with application number [appId] by default.
  final UpdateCallback? updateCallback;

  /// Use [cancelCallback] to implement the event listener of clicking the cancel button.
  /// It is to close the dialog by default.
  final UpdateCallback? cancelCallback;
}
