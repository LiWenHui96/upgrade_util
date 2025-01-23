import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'upgrade_util_method_channel.dart';

abstract class UpgradeUtilPlatform extends PlatformInterface {
  /// Constructs a UpgradeUtilPlatform.
  UpgradeUtilPlatform() : super(token: _token);

  static final Object _token = Object();

  static UpgradeUtilPlatform _instance = MethodChannelUpgradeUtil();

  /// The default instance of [UpgradeUtilPlatform] to use.
  ///
  /// Defaults to [MethodChannelUpgradeUtil].
  static UpgradeUtilPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UpgradeUtilPlatform] when
  /// they register themselves.
  static set instance(UpgradeUtilPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
