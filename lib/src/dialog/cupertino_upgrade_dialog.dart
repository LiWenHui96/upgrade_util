import 'package:flutter/cupertino.dart';
import 'package:upgrade_util/src/config/ios_upgrade_config.dart';

/// @Describe: Displays an iOS-style upgrade dialog above the current contents of the app.
///
/// @Author: LiWeNHuI
/// @Date: 2022/5/27

Future<T?> showCupertinoUpgradeDialog<T>(
  BuildContext context, {
  required Widget child,
  String? barrierLabel,
  RouteSettings? routeSettings,
}) {
  return showCupertinoDialog(
    context: context,
    builder: (_) => child,
    barrierLabel: barrierLabel,
    routeSettings: routeSettings,
  );
}

/// The widget of iOS-style upgrade dialog.
@protected
class CupertinoUpgradeDialog extends StatefulWidget {
  const CupertinoUpgradeDialog({
    Key? key,
    required this.iOSUpgradeConfig,
    required this.force,
    required this.title,
    required this.content,
    required this.updateText,
    this.updateTextStyle,
    required this.cancelText,
    this.cancelTextStyle,
    required this.onUpgradePressed,
    required this.onCancelPressed,
  }) : super(key: key);

  /// iOS upgrade config.
  /// Only iOS is supported.
  ///
  /// It is required.
  final IosUpgradeConfig iOSUpgradeConfig;

  /// Whether to force the update, there is no cancel button
  /// when forced.
  ///
  /// It is `false` by default.
  final bool force;

  /// A title of the version.
  final Widget title;

  /// A description of the version.
  final Widget content;

  /// Text message of the update button.
  final String updateText;

  /// The text style of [updateText].
  final TextStyle? updateTextStyle;

  /// Text message of cancel button.
  final String cancelText;

  /// The text style of [cancelText].
  final TextStyle? cancelTextStyle;

  /// Click event of Updates button.
  final VoidCallback? onUpgradePressed;

  /// Click event of Cancel button.
  final VoidCallback? onCancelPressed;

  @override
  State<CupertinoUpgradeDialog> createState() => _CupertinoUpgradeDialogState();
}

class _CupertinoUpgradeDialogState extends State<CupertinoUpgradeDialog> {
  @override
  Widget build(BuildContext context) {
    final CupertinoDialogAction cancelAction = CupertinoDialogAction(
      onPressed: widget.onCancelPressed,
      isDestructiveAction: iOSUpgradeConfig.isCancelDestructiveAction,
      isDefaultAction: iOSUpgradeConfig.isCancelDefaultAction,
      textStyle: widget.cancelTextStyle,
      child: Text(widget.cancelText),
    );

    final CupertinoDialogAction updateAction = CupertinoDialogAction(
      onPressed: widget.onUpgradePressed,
      isDefaultAction: force ? force : iOSUpgradeConfig.isUpgradeDefaultAction,
      isDestructiveAction: iOSUpgradeConfig.isUpgradeDestructiveAction,
      textStyle: widget.updateTextStyle,
      child: Text(widget.updateText, ),
    );

    return CupertinoAlertDialog(
      title: widget.title,
      content: widget.content,
      scrollController: iOSUpgradeConfig.scrollController,
      actionScrollController: iOSUpgradeConfig.actionScrollController,
      actions: <Widget>[
        if (!force) cancelAction,
        updateAction,
      ],
    );
  }

  IosUpgradeConfig get iOSUpgradeConfig => widget.iOSUpgradeConfig;

  bool get force => widget.force;
}
