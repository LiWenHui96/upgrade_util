/// @Describe: Upgrade Option.
///
/// @Author: LiWeNHuI
/// @Date: 2025/2/18

part of '../upgrade_util.dart';

abstract class UpgradeOption {
  UpgradeOption({this.parameters});

  final Map<String, dynamic>? parameters;

  /// 跳转链接
  String get url;
}

class AndroidUpgradeOption extends UpgradeOption {
  AndroidUpgradeOption({
    this.packageName,
    super.parameters,
  });

  /// The package name.
  final String? packageName;

  @override
  String get url => '';
}

class IOSUpgradeOption extends UpgradeOption {
  IOSUpgradeOption({
    required this.appId,
    required this.mode,
    super.parameters,
  });

  /// Apple ID.
  final String appId;

  /// Open Mode.
  final IOSOpenMode mode;

  @override
  String get url {
    String url = mode.link.replace(<dynamic>[appId]);
    if (parameters != null) url = url.addParameters(parameters!);
    return url;
  }
}
