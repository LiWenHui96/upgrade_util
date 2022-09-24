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
  // ignore: public_member_api_docs
  const CupertinoUpgradeDialog({
    Key? key,
    required this.iOSUpgradeConfig,
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
      isDestructiveAction: config.isCancelDestructiveAction,
      isDefaultAction: config.isCancelDefaultAction,
      textStyle: widget.cancelTextStyle,
      child: Text(widget.cancelText),
    );

    final CupertinoDialogAction updateAction = CupertinoDialogAction(
      onPressed: () {
        widget.onUpgradePressed?.call(null);
      },
      isDefaultAction: force ? force : config.isUpgradeDefaultAction,
      isDestructiveAction: config.isUpgradeDestructiveAction,
      textStyle: widget.updateTextStyle,
      child: Text(widget.updateText),
    );

    return CupertinoAlertDialog(
      title: widget.title,
      content: widget.content,
      scrollController: config.scrollController,
      actionScrollController: config.actionScrollController,
      actions: <Widget>[
        if (!force) cancelAction,
        updateAction,
      ],
    );
  }

  IosUpgradeConfig get config => widget.iOSUpgradeConfig;

  bool get force => widget.force;
}
