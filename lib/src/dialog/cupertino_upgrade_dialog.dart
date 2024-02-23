import 'package:flutter/cupertino.dart';
import 'package:upgrade_util/src/upgrade_config.dart';

/// @Describe: Displays an iOS-style upgrade dialog above the current contents
///            of the app.
///
/// @Author: LiWeNHuI
/// @Date: 2022/5/27

Future<T?> showCupertinoUpgradeDialog<T>(
  BuildContext context, {
  required Widget child,
  String? barrierLabel,
  bool useRootNavigator = true,
  bool barrierDismissible = false,
  RouteSettings? routeSettings,
}) {
  return showCupertinoDialog(
    context: context,
    builder: (_) => child,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    barrierDismissible: barrierDismissible,
    routeSettings: routeSettings,
  );
}

/// The widget of iOS-style upgrade dialog.
@protected
class CupertinoUpgradeDialog extends StatefulWidget {
  const CupertinoUpgradeDialog({
    Key? key,
    required this.config,
    required this.force,
    required this.title,
    this.content,
    required this.updateText,
    this.updateTextStyle,
    required this.cancelText,
    this.cancelTextStyle,
    required this.onUpgradePressed,
    required this.onCancelPressed,
  }) : super(key: key);

  /// Configuration information used for iOS upgrades. Including appleId,
  /// isUpgradeDefaultAction, isUpgradeDestructiveAction, etc.
  final IosUpgradeConfig config;

  /// Whether to force the update, there is no cancel button when forced.
  ///
  /// It is `false` by default.
  final bool force;

  /// A title of the version.
  final Widget title;

  /// A description of the version.
  final Widget? content;

  /// Text message of the update button.
  final String updateText;

  /// The text style of [updateText].
  final TextStyle? updateTextStyle;

  /// Text message of cancel button.
  final String cancelText;

  /// The text style of [cancelText].
  final TextStyle? cancelTextStyle;

  /// Click event of Updates button.
  final ValueChanged<String?>? onUpgradePressed;

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
      isDefaultAction: config.isCancelDefaultAction,
      isDestructiveAction: config.isCancelDestructiveAction,
      textStyle: widget.cancelTextStyle,
      child: Text(widget.cancelText),
    );

    final bool isUpgradeDestructiveAction = config.isUpgradeDestructiveAction;
    TextStyle? updateTextStyle = widget.updateTextStyle;
    if (!isUpgradeDestructiveAction) {
      updateTextStyle ??= const TextStyle(color: CupertinoColors.systemBlue);
    }

    final CupertinoDialogAction updateAction = CupertinoDialogAction(
      onPressed: () => widget.onUpgradePressed?.call(null),
      isDefaultAction: force ? force : config.isUpgradeDefaultAction,
      isDestructiveAction: isUpgradeDestructiveAction,
      textStyle: updateTextStyle,
      child: Text(widget.updateText),
    );

    return CupertinoAlertDialog(
      title: widget.title,
      content: widget.content,
      actions: <Widget>[if (!force) cancelAction, updateAction],
      scrollController: config.scrollController,
      actionScrollController: config.actionScrollController,
      insetAnimationDuration: config.insetAnimationDuration,
      insetAnimationCurve: config.insetAnimationCurve,
    );
  }

  IosUpgradeConfig get config => widget.config;

  bool get force => widget.force;
}
