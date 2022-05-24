import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:upgrade_util/upgrade_util.dart';

/// @Describe: Upgrade function class
///
/// @Author: LiWeNHuI
/// @Date: 2022/2/23

class UpgradeUtil {
  static const MethodChannel _channel = MethodChannel(channelName);

  static Future<String?> get platformVersion async =>
      _channel.invokeMethod('getPlatformVersion');

  /// Get the download path of the software.
  ///
  /// This uses the `getCacheDir` API on the context.
  ///
  /// Use [softwareName] as the software name.
  /// It is `temp.apk` by default.
  static Future<String> getDownloadPath({String? softwareName}) async {
    if (!Platform.isAndroid) {
      throw UnimplementedError('Only Android platforms are supported.');
    }

    final String? result = await _channel.invokeMethod('downloadPath');
    return '$result${softwareName ?? 'temp.apk'}';
  }

  /// Install apk.
  ///
  /// Jump to the APK installation page.
  ///
  /// The [path] is the storage address of apk.
  static Future<bool?> installApk(String path) async {
    if (!Platform.isAndroid) {
      throw UnimplementedError('Other platforms are not supported for now');
    }

    final Map<String, String> map = <String, String>{'path': path};
    final bool? result = await _channel.invokeMethod('installApk', map);
    return result;
  }

  /// Gets the package name of the available market.
  ///
  /// When set to true, make sure your program is on the market.
  /// This plug-in does not verify that your program is on the shelf.
  static Future<List<AndroidMarketModel>> getAvailableMarket({
    AndroidMarket? androidMarket,
    List<String>? otherMarkets,
  }) async {
    if (!Platform.isAndroid) {
      throw UnimplementedError('Other platforms are not supported for now');
    }

    final List<String> list = (androidMarket ?? AndroidMarket()).toMarkets()
      ..addAll(otherMarkets ?? <String>[]);

    final List<dynamic>? result = await _channel.invokeMethod(
      'availableMarket',
      <String, List<String>>{'packages': list},
    );

    if (result == null) {
      throw NullThrownError();
    }

    final List<AndroidMarketModel> markets = result
        .map(
          (dynamic e) => AndroidMarketModel.fromJson(
            json.decode(json.encode(e)) as Map<String, dynamic>,
          ),
        )
        .toList();

    return markets;
  }

  /// The [jumpMode] is jump mode.
  ///
  /// On iOS, the 'appId' is App Store ID.
  ///
  /// On Android, the 'appId' is package name.
  /// On Android, the 'marketPackageName' is the package name of market.
  static Future<void> jumpToStore({
    required JumpMode jumpMode,
    String? iOSAppId,
    String? androidPackageName,
    String? androidMarketPackageName,
  }) async {
    if (Platform.isAndroid) {
      if (jumpMode == JumpMode.detailPage) {
        if (androidPackageName == null) {
          throw ArgumentError('The package name are empty');
        }

        await _channel.invokeMethod<void>('jumpToMarket', <String, dynamic>{
          'packageName': androidPackageName,
          'marketPackageName': androidMarketPackageName,
        });
      } else {
        throw UnimplementedError('Other mode are not supported for now');
      }
    } else if (Platform.isIOS) {
      if (iOSAppId == null) {
        throw ArgumentError('The appId are empty');
      }

      switch (jumpMode) {
        case JumpMode.detailPage:
          await _jumpToDetailPage(appId: iOSAppId);
          break;
        case JumpMode.reviewsPage:
          await _jumpToReviewsPage(appId: iOSAppId);
          break;
        case JumpMode.writeReview:
          await _jumpToWriteReviews(appId: iOSAppId);
          break;
      }
    } else {
      throw UnimplementedError('Other platforms are not supported for now');
    }
  }

  /// Jump to the details page of App Store.
  ///
  /// The [appId] is App Store ID.
  static Future<bool> _jumpToDetailPage({required String appId}) async =>
      _launchUrl('$detailPageUrl$appId');

  /// Jump to the reviews page of App Store.
  ///
  /// The [appId] is App Store ID.
  static Future<bool> _jumpToReviewsPage({required String appId}) async =>
      _launchUrl('$reviewsPageUrl$appId');

  /// Jump to App Store and leave a review.
  ///
  /// The [appId] is App Store ID.
  static Future<bool> _jumpToWriteReviews({required String appId}) async =>
      _launchUrl('$detailPageUrl$appId$writeReviewUrl');

  /// On iOS, implement link jump.
  static Future<bool> _launchUrl(
    String url, {
    bool universalLinksOnly = false,
  }) async {
    // splicing url
    url += url.contains('?') ? '&' : '?';
    url += 'ls=1&mt=8';

    final bool? result = await _channel.invokeMethod('launch', <String, Object>{
      'url': url,
      'universalLinksOnly': universalLinksOnly,
    });
    if (result == null) {
      throw UnimplementedError('Other platforms are not supported for now');
    }
    return result;
  }
}

/// iOS - Jump to the link address of the AppStore details page.
/// Another link: itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=
const String detailPageUrl =
    'itms-apps://itunes.apple.com/cn/app/apple-store/id';

/// iOS - Jump to the link address of the AppStore review page
const String reviewsPageUrl =
    'itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=';

/// iOS - The suffix of the link to jump to the AppStore and comment.
const String writeReviewUrl = '?action=write-review';
