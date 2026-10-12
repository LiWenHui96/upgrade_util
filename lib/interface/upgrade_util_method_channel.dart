part of 'upgrade_util.dart';

/// An implementation of [UpgradeUtilPlatform] that uses method channels.
class MethodChannelUpgradeUtil extends UpgradeUtilPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('upgrade_util');

  @override
  Future<void> launch({required UpgradeOpenType type, String? packageName, String? appleID}) async {
    if (defaultTargetPlatform == .android) {
    } else if (defaultTargetPlatform == .iOS) {
      return _launchAppStore(type: type, id: appleID);
    } else {
      throw UnsupportedError(
        'Opening the ${type.name} page is not supported on $defaultTargetPlatform. '
        'Only ${type == .reviews ? 'iOS is' : 'Android and iOS are'} currently supported by upgrade_util.',
      );
    }
  }

  /// iOS 端根据 [type] 拼接 App Store 链接，并通过原生通道打开。
  ///
  /// [id] 为 App 的 Apple ID，可在 App Store Connect 的「App 信息」中查看，iOS 端必传。
  Future<void> _launchAppStore({required UpgradeOpenType type, String? id}) async {
    if (id == null || id.isEmpty) throw ArgumentError.value(id, 'id', 'The Apple ID is required on iOS.');

    final String url = switch (type) {
      .detail => 'apps.apple.com/app/id$id',
      .reviews => 'itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=$id&type=Purple+Software',
      .review => 'apps.apple.com/app/id$id?action=write-review',
    };
    await methodChannel.invokeMethod<void>('launch', <String, String>{'url': 'itms-apps://$url'});
  }
}
