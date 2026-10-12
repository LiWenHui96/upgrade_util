part of 'upgrade_util.dart';

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

  /// {@template upgrade.util.launch}
  /// 跳转至应用商店
  ///
  /// [type] 打开类型，参见 [UpgradeOpenType]。
  ///
  /// [packageName] 目标应用包名，可不传；不传时 Android 默认使用本应用包名；iOS 不使用该参数。
  ///
  /// [appleID] App 的 Apple ID，iOS 必传，Android 不使用该参数。
  /// 获取方式：App Store Connect（https://appstoreconnect.apple.com）→ 我的 App → 选择对应 App → 「App 信息」中的「Apple ID」；
  /// 也可从 App Store 链接 `https://apps.apple.com/app/id<AppleID>` 中 `id` 后的数字部分获取。
  /// {@endtemplate}
  Future<void> launch({required UpgradeOpenType type, String? packageName, String? appleID}) {
    throw UnimplementedError('launch() has not been implemented.');
  }
}
