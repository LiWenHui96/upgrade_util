import 'package:flutter_test/flutter_test.dart';
import 'package:upgrade_util/upgrade_util_method_channel.dart';
import 'package:upgrade_util/upgrade_util_platform_interface.dart';

void main() {
  final UpgradeUtilPlatform initialPlatform = UpgradeUtilPlatform.instance;

  test('$MethodChannelUpgradeUtil is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUpgradeUtil>());
  });
}
