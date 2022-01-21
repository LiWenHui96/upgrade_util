import 'dart:io';

import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// @Describe: iOS upgrade function class
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/14

/// iOS - Jump to the link address of the AppStore details page.
/// Another link: itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=
const String detailPageUrl =
    'itms-apps://itunes.apple.com/cn/app/apple-store/id';

/// iOS - Jump to the link address of the AppStore review page
const String reviewsPageUrl =
    'itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=';

/// iOS - The suffix of the link to jump to the AppStore and comment.
const String writeReviewUrl = '?action=write-review';

/// iOS - jump mode
enum EIOSJumpMode { detailPage, reviewsPage, writeReview }

class IOSUpgradeUtil {
  /// The [eIOSJumpMode] is jump mode.
  /// It is `EIOSJumpMode.detailPage` by default.
  ///
  /// The [appId] is App Store ID
  static Future<bool> jumpToAppStore({
    required EIOSJumpMode eIOSJumpMode,
    required String appId,
  }) async {
    switch (eIOSJumpMode) {
      case EIOSJumpMode.detailPage:
        return _jumpToDetailPage(appId: appId);
      case EIOSJumpMode.reviewsPage:
        return _jumpToReviewsPage(appId: appId);
      case EIOSJumpMode.writeReview:
        return _jumpToWriteReviews(appId: appId);
    }
  }

  /// Method - iOS - Jump to the details page of App Store.
  ///
  /// The [appId] is App Store ID.
  static Future<bool> _jumpToDetailPage({required String appId}) async =>
      _launchUrl('$detailPageUrl$appId');

  /// Method - iOS - Jump to the reviews page of App Store.
  ///
  /// The [appId] is App Store ID.
  static Future<bool> _jumpToReviewsPage({required String appId}) async =>
      _launchUrl('$reviewsPageUrl$appId');

  /// Method - iOS - Jump to App Store and leave a review.
  ///
  /// The [appId] is App Store ID.
  static Future<bool> _jumpToWriteReviews({required String appId}) async =>
      _launchUrl('$detailPageUrl$appId$writeReviewUrl');

  /// Launch link
  static Future<bool> _launchUrl(String url) async {
    if (Platform.isIOS) {
      // splicing url
      url += url.contains('?') ? '&' : '?';
      url += 'ls=1&mt=8';

      final launcher = UrlLauncherPlatform.instance;
      if (await launcher.canLaunch(url))
        return launcher.launch(
          url,
          useSafariVC: false,
          useWebView: false,
          enableJavaScript: false,
          enableDomStorage: false,
          universalLinksOnly: false,
          headers: const <String, String>{},
        );
      else
        return false;
    } else {
      throw 'For iOS only.';
    }
  }
}
