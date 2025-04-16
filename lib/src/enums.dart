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
  google(label: 'Google'),

  /// 华为
  huawei(link: 'appmarket://details?id=%s', label: '华为'),

  /// 荣耀
  honor(label: '荣耀'),

  /// 小米/红米
  xiaomi(label: '小米'),

  /// OPPO/realme/OnePlus
  oppo(label: 'OPPO'),

  /// vivo/iqoo
  vivo(link: 'vivomarket://details?id=%s', label: 'vivo'),

  /// 魅族
  meizu(label: '魅族'),

  /// 腾讯应用宝
  tencent(label: '腾讯应用宝'),

  /// 百度
  baidu(label: '百度'),

  /// If you use a custom link, you need to use [AndroidUpgradeOption.link].
  custom();

  const AndroidBrand({this.link, this.label});

  /// Link.
  final String? link;

  /// label
  final String? label;

  /// Whether to use a custom link.
  bool get isNeedLink =>
      this == AndroidBrand.xiaomi || this == AndroidBrand.custom;
}
