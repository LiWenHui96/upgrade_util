part of 'upgrade_util.dart';

/// An implementation of [UpgradeUtilPlatform] that uses method channels.
class MethodChannelUpgradeUtil extends UpgradeUtilPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('upgrade_util');

  @override
  Future<bool> launch({required UpgradeOpenType type, String? packageName, String? appleID}) async {
    return switch (defaultTargetPlatform) {
      .android => _launchOnAndroid(type: type, packageName: packageName),
      .iOS => _launchAppStore(type: type, id: appleID),
      _ => throw UnsupportedError(
        'Opening the ${type.name} page is not supported on $defaultTargetPlatform. '
        'Only ${type == .reviews ? 'iOS is' : 'Android and iOS are'} currently supported by upgrade_util.',
      ),
    };
  }

  /// Android 端：调用原生方法打开对应的应用市场页面
  ///
  /// [UpgradeOpenType.detail] 与 [UpgradeOpenType.review] 分别映射为原生方法
  /// `launchDetail` 与 `launchReview`；[UpgradeOpenType.reviews] 仅 iOS 支持
  Future<bool> _launchOnAndroid({required UpgradeOpenType type, String? packageName}) async {
    final String method = switch (type) {
      .detail => 'launchDetail',
      .reviews => throw UnsupportedError(
        'Opening the ${type.name} page is not supported on Android. '
        '${UpgradeOpenType.reviews.name} is only supported on iOS.',
      ),
      .review => 'launchReview',
    };
    return _invoke(method, <String, String?>{'packageName': packageName});
  }

  /// iOS 端：根据 [type] 拼接 App Store 链接，并通过原生通道打开
  ///
  /// [id] 为 App 的 Apple ID，可在 App Store Connect 的「App 信息」中查看，iOS 端必传
  Future<bool> _launchAppStore({required UpgradeOpenType type, String? id}) async {
    if (id == null || id.isEmpty) throw ArgumentError.value(id, 'id', 'The Apple ID is required on iOS.');

    final String url = switch (type) {
      .detail => 'apps.apple.com/app/id$id',
      .reviews => 'itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=$id&type=Purple+Software',
      .review => 'apps.apple.com/app/id$id?action=write-review',
    };
    return _invoke('launch', <String, String>{'url': 'itms-apps://$url'});
  }

  /// 通过通道调用原生 [method]；原生侧未返回结果时视为打开失败
  Future<bool> _invoke(String method, Map<String, Object?> arguments) async {
    return await methodChannel.invokeMethod<bool>(method, arguments) ?? false;
  }
}
