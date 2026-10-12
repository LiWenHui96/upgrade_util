library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show MethodChannel;
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../src/enum.dart';

part 'upgrade_util_method_channel.dart';

part 'upgrade_util_platform_interface.dart';

class UpgradeUtil {
  /// {@macro upgrade.util.launch}
  static Future<bool> launch({required UpgradeOpenType type, String? packageName, String? appleID}) =>
      UpgradeUtilPlatform.instance.launch(type: type, packageName: packageName, appleID: appleID);
}
