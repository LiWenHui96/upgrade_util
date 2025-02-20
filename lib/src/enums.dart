/// @Describe: Enums.
///
/// @Author: LiWeNHuI
/// @Date: 2025/2/17

part of '../upgrade_util.dart';

enum IOSOpenMode {
  /// Product page.
  product('$_iOSPrefixUrl/app/apple-store/id%s'),

  /// Reviews page.
  reviews('$_iOSPrefixUrl/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%s&type=Purple+Software'),

  /// Write a review.
  writeReview('$_iOSPrefixUrl/app/apple-store/id%s?action=write-review');

  const IOSOpenMode(this.link);

  /// Link.
  final String link;
}

enum AndroidOpenMode {
  /// Product page.
  product('market://details?id=%s'),

  /// Reviews page.
  reviews('market://search?q=pub:%s'),

  /// Write a review.
  writeReview('market://details?id=%s&showAllReviews=true');

  const AndroidOpenMode(this.link);

  /// Link.
  final String link;
}

const String _iOSPrefixUrl = 'itms-apps://itunes.apple.com';
