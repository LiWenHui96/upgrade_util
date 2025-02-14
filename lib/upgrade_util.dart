import 'upgrade_util_platform_interface.dart';

class UpgradeUtil {
  Future<String?> getPlatformVersion() {
    return UpgradeUtilPlatform.instance.getPlatformVersion();
  }
}
