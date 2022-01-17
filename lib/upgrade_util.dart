import 'dart:async';

import 'package:flutter/services.dart';

class UpgradeUtil {
  static const MethodChannel _channel = MethodChannel('upgrade_util');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
export 'src/update_localizations.dart';
export 'src/update_localizations_delegate.dart';
