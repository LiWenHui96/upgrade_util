import 'package:flutter/material.dart';
import 'package:upgrade_util/src/config/android_upgrade_config.dart';

/// @Describe: Displays a Material upgrade dialog above the current contents of the app.
///
/// @Author: LiWeNHuI
/// @Date: 2022/5/27

Future<T?> showMaterialUpgradeDialog<T>(
  BuildContext context, {
  required Widget child,
  Color? barrierColor,
  String? barrierLabel,
  RouteSettings? routeSettings,
}) {
  return showDialog(
    context: context,
    builder: (_) => child,
    barrierColor: barrierColor ?? const Color.fromRGBO(0, 0, 0, .4),
    barrierLabel: barrierLabel,
    routeSettings: routeSettings,
  );
}

/// The widget of Material upgrade dialog.
@protected
class MaterialUpgradeDialog extends StatefulWidget {
  const MaterialUpgradeDialog({
    Key? key,
    required this.androidUpgradeConfig,
    required this.force,
    required this.title,
    required this.content,
    required this.updateText,
    this.updateTextStyle,
    required this.cancelText,
    this.cancelTextStyle,
    this.isShowIndicator = false,
    this.downloadProgress = .0,
    required this.onUpgradePressed,
    required this.onCancelPressed,
  }) : super(key: key);

  /// Android upgrade config.
  /// Only Android is supported.
  ///
  /// It is required.
  final AndroidUpgradeConfig androidUpgradeConfig;

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

  /// Whether the indicator is displayed
  final bool isShowIndicator;

  /// Download progress
  final double downloadProgress;

  /// Click event of Updates button.
  final VoidCallback? onUpgradePressed;

  /// Click event of Cancel button.
  final VoidCallback? onCancelPressed;

  @override
  State<MaterialUpgradeDialog> createState() => _MaterialUpgradeDialogState();
}

class _MaterialUpgradeDialogState extends State<MaterialUpgradeDialog> {
  @override
  Widget build(BuildContext context) {
    final Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(child: _buildContent()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: widget.downloadProgress > 0
              ? _buildDownloadAction()
              : _buildBasicActions(),
        ),
      ],
    );

    return Dialog(
      backgroundColor: const Color(0xFFFEFEFE),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 270,
        child: Padding(padding: const EdgeInsets.all(8), child: child),
      ),
    );
  }

  Widget _buildContent() {
    final Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DefaultTextStyle(
          style: TextStyle(
            color: Colors.black.withOpacity(.95),
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            height: 1.5,
            textBaseline: TextBaseline.alphabetic,
          ),
          textAlign: TextAlign.center,
          child: widget.title,
        ),
        const SizedBox(height: 2),
        DefaultTextStyle(
          style: TextStyle(
            color: Colors.black.withOpacity(.9),
            height: 1.5,
            textBaseline: TextBaseline.alphabetic,
          ),
          textAlign: TextAlign.center,
          child: widget.content,
        ),
      ],
    );

    return Scrollbar(
      radius: const Radius.circular(10),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        physics: const BouncingScrollPhysics(),
        child: child,
      ),
    );
  }

  Widget _buildBasicActions() {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: widget.isShowIndicator ? null : widget.onUpgradePressed,
          style: ButtonStyle(
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 40)),
            elevation: MaterialStateProperty.all(0),
          ),
          child: Text(
            widget.isShowIndicator ? '正在跳转...' : widget.updateText,
            style: widget.updateTextStyle,
          ),
        ),
        if (!widget.force)
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: InkWell(
              onTap: widget.onCancelPressed,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  widget.cancelText,
                  style: widget.cancelTextStyle?.copyWith(color: Colors.grey) ??
                      const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDownloadAction() {
    const double height = 10.0;

    return Column(
      children: <Widget>[
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: height,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(height)),
                  child: LinearProgressIndicator(
                    value: downloadProgress,
                    backgroundColor: config.indicatorBackgroundColor,
                    color: config.indicatorColor,
                    valueColor: config.indicatorValueColor,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${(downloadProgress * 100).toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: config.indicatorTextColor ?? Colors.white,
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!widget.force)
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: ElevatedButton(
              onPressed: () async => Navigator.pop(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) => const Color(0xFFDFDFDF)),
                elevation: MaterialStateProperty.all(0),
                minimumSize:
                    MaterialStateProperty.all(const Size(double.infinity, 32)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                )),
              ),
              child: Text(config.downloadCancelText ?? ''),
            ),
          ),
      ],
    );
  }

  double get downloadProgress => widget.downloadProgress;

  AndroidUpgradeConfig get config => widget.androidUpgradeConfig;
}
