/// @Describe: Enums.
///
/// @Author: LiWeNHuI
/// @Date: 2025/2/17

part of '../upgrade_util.dart';

enum IOSOpenMode {
  /// Product page.
  product('/app/apple-store/id%s'),

  /// Reviews page.
  reviews(
    '/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%s&type=Purple+Software',
  ),

  /// Write a review.
  writeReview('/app/apple-store/id%s?action=write-review');

  const IOSOpenMode(this.link);

  /// Link.
  final String link;
}

enum AndroidBrand {
  /// Google
  google(),

  /// 华为
  huawei(link: 'appmarket://details?id=%s'),

  /// 荣耀
  honor(),

  /// 小米/红米
  xiaomi(),

  /// OPPO/realme/OnePlus
  oppo(),

  /// vivo/iqoo
  vivo(link: 'vivomarket://details?id=%s'),

  /// 魅族
  meizu(),

  /// 腾讯应用宝
  tencent(),

  /// If you use a custom link, you need to use [AndroidUpgradeOption.link].
  custom();

  const AndroidBrand({this.link});

  /// Link.
  final String? link;

  /// Whether to use a custom link.
  bool get isNeedLink =>
      this == AndroidBrand.xiaomi || this == AndroidBrand.custom;
}
