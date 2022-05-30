import 'package:flutter/cupertino.dart';

/// @Describe: iOS Upgrade Config
///
/// @Author: LiWeNHuI
/// @Date: 2022/5/27

class IosUpgradeConfig {
  /// Externally provided
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
