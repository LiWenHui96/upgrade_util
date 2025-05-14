/// @Describe: Upgrade Option.
///
/// @Author: LiWeNHuI
/// @Date: 2025/2/18

library;

abstract class UpgradeOption {
  UpgradeOption({this.parameters});

  /// Custom parameters; stitched after [url].
  final Map<String, dynamic>? parameters;

  /// Link.
  Future<String> get url;
}

const String iOSPrefixUrl = 'itms-apps://itunes.apple.com';
const String AndroidPrefixUrl = 'market://details?id=%s';
