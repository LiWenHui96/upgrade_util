import 'package:flutter/material.dart';

/// @Describe: Upgrade Config
///
/// @Author: LiWeNHuI
/// @Date: 2022/5/27

class UpgradeConfig {
  /// Externally provided
  UpgradeConfig({
    this.force = false,
    required this.title,
    this.titleTextStyle,
    this.titleStrutStyle,
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

  /// A title of the version.
  late String? title;

  /// The text style of [title].
  final TextStyle? titleTextStyle;

  /// The strut style of [title].
  final StrutStyle? titleStrutStyle;

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
