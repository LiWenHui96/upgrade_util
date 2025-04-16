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

/// Android Upgrade Option.
///
/// 如果手机厂商为OPPO，[parameters] 支持拼接参数
/// https://open.oppomobile.com/new/developmentDoc/info?id=11869
///
/// 如果手机厂商为vivo，[parameters] 支持拼接参数
/// https://swsdl.vivo.com.cn/appstore/developer/uploadFile/20241224/vxpbua/vivo%E5%BC%80%E6%94%BE%E5%B9%B3%E5%8F%B0%E5%95%86%E5%BA%97%E8%87%AA%E6%9B%B4%E6%96%B02.0.pdf
///
/// 如果手机厂商为小米，因小米已关闭直投1.0模式，故建议采用统一链接服务（OneLink）或者直投2.0模式
/// 如果使用直投2.0，请确保已开通直投2.0服务，否则无法正常跳转，并将额外参数通过[parameters]传入。
/// 统一链接服务（OneLink）操作指南: https://dev.mi.com/xiaomihyperos/documentation/detail?pId=1965
/// 直投2.0: https://dev.mi.com/xiaomihyperos/documentation/detail?pId=1350
///
/// 统一链接服务（OneLink）目前支持华为、小米、OPPO、vivo、Apple以及PC
/// https://www.malink.cn/
class AndroidUpgradeOption extends UpgradeOption {
  AndroidUpgradeOption({
    required this.brand,
    this.packageName,
    this.link,
    this.isUseDownloadUrl = false,
    this.downloadUrl,
    super.parameters,
  });

  /// The brand.
  final AndroidBrand brand;

  /// The package name.
  String? packageName;

  /// Custom link.
  /// Used for [AndroidBrand.xiaomi] and [AndroidBrand.custom].
  final String? link;

  /// Whether to use download url.
  final bool isUseDownloadUrl;

  /// Download url.
  final String? downloadUrl;

  @override
  String get url {
    /// If [isUseDownloadUrl] is true, it will directly return [downloadUrl].
    if (isUseDownloadUrl) {
      return downloadUrl ?? '';
    }

    /// Otherwise, jump to the application market.
    String url = '';
    if (brand.isNeedLink && !link.isBlank) {
      url = link.replace(<dynamic>[packageName]);
    } else {
      url = brand.link ?? AndroidPrefixUrl;
      url = url.replace(<dynamic>[packageName]);
    }
    if (parameters != null) url = url.addParameters(parameters!);
    return url;
  }
}

/// IOS Upgrade Option.
///
/// [appleId] You only need to configure `Apple ID`.
/// After logging in to `App Store Connect`, find `Apple ID`
/// through `Comprehensive` -> `App Information` -> `Comprehensive Information`.
///
/// Select the opening [mode] of AppStore.
class IOSUpgradeOption extends UpgradeOption {
  IOSUpgradeOption({
    required this.appleId,
    required this.mode,
    super.parameters,
  });

  /// Apple ID.
  final String appleId;

  /// Open Mode.
  final IOSOpenMode mode;

  @override
  String get url {
    String url = (iOSPrefixUrl + mode.link).replace(<dynamic>[appleId]);
    if (parameters != null) url = url.addParameters(parameters!);
    return url;
  }
}
