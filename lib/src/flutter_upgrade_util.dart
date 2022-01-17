import 'dart:io';

import 'package:flutter/services.dart';
import 'package:upgrade_util/upgrade_util.dart';

///
/// @Describe:
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/17
///

class UpgradeUtil {
  static const _channel = MethodChannel('upgrade_util');

  /// This is the app upgrade method.
  ///
  /// The [appKey] is required.
  static Future<bool> upgradeApp({
    required String appKey,
    EIOSJumpMode? eIOSJumpMode,
  }) async {
    if (Platform.isIOS) {
      return IOSUpdateUtil.jumpToAppStore(
        eIOSJumpMode: eIOSJumpMode ?? EIOSJumpMode.detailPage,
        appId: appKey,
      );
    } else if (Platform.isAndroid) {
      throw 'Wait.';
    } else {
      throw 'Unsupported platform.';
    }
  }
}
