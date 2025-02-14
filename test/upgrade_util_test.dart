import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:upgrade_util/upgrade_util.dart';
import 'package:upgrade_util/upgrade_util_method_channel.dart';
import 'package:upgrade_util/upgrade_util_platform_interface.dart';

class MockUpgradeUtilPlatform
    with MockPlatformInterfaceMixin
    implements UpgradeUtilPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final UpgradeUtilPlatform initialPlatform = UpgradeUtilPlatform.instance;

  test('$MethodChannelUpgradeUtil is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUpgradeUtil>());
  });

  test('getPlatformVersion', () async {
    final UpgradeUtil upgradeUtilPlugin = UpgradeUtil();
    final MockUpgradeUtilPlatform fakePlatform = MockUpgradeUtilPlatform();
    UpgradeUtilPlatform.instance = fakePlatform;

    expect(await upgradeUtilPlugin.getPlatformVersion(), '42');
  });
}
