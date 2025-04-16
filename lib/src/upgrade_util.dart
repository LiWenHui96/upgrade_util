/// @Describe: Upgrade tools
///
/// @Author: LiWeNHuI
/// @Date: 2025/2/14

part of '../upgrade_util.dart';

class UpgradeUtil {
  Future<String?> getPlatformVersion() {
    return UpgradeUtilPlatform.instance.getPlatformVersion();
  }

  /// {@macro upgrade.util.openStore}
  static Future<void> openStore({
    AndroidUpgradeOption? androidOption,
    IOSUpgradeOption? iOSOption,
  }) {
    return UpgradeUtilPlatform.instance.openStore(
      androidOption: androidOption,
      iOSOption: iOSOption,
    );
  }
}
