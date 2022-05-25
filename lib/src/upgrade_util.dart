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
      throw UnimplementedError('Only Android is currently supported.');
    }

    final String? result = await _channel.invokeMethod('getDownloadPath');
    return '$result${softwareName ?? 'temp.apk'}';
  }

  /// Install apk.
  ///
  /// Jump to the installation page of the software.
  ///
  /// The [path] is the storage address of apk.
  static Future<bool?> installApk(String path) async {
    if (!Platform.isAndroid) {
      throw UnimplementedError('Only Android is currently supported.');
    }

    return _channel.invokeMethod('installApk', path);
  }

  /// Get the software information of the application market included
  /// in the mobile phone.
  ///
  /// When set to true, make sure your program is on the market.
  /// This plug-in does not verify that your program is on the shelf.
  static Future<List<AndroidMarketModel>> getMarkets({
    AndroidMarket? androidMarket,
    List<String>? otherMarkets,
  }) async {
    if (!Platform.isAndroid) {
      throw UnimplementedError('Only Android is currently supported.');
    }

    final List<String> packages = (androidMarket ?? AndroidMarket()).toMarkets()
      ..addAll(otherMarkets ?? <String>[]);

    final List<Map<dynamic, dynamic>>? markets =
        await _channel.invokeListMethod('getMarkets', packages);

    if (markets == null) {
      return <AndroidMarketModel>[];
    }

    return markets
        .map((Map<dynamic, dynamic> e) => AndroidMarketModel.fromJson(e))
        .toList();
  }

  /// The [jumpMode] is jump mode.
  ///
  /// On iOS, the [iOSAppleId] is Apple ID.
  ///
  /// On Android, the [androidPackageName] is package name.
  /// the [androidMarketPackageName] is the package name of market.
  static Future<void> jumpToStore({
    required JumpMode jumpMode,
    String? iOSAppleId,
    String? androidPackageName,
    String? androidMarketPackageName,
  }) async {
    if (Platform.isAndroid) {
      assert(
        androidPackageName == null,
        'The name of the package cannot be empty.',
      );

      await _channel.invokeMethod<void>('jumpToMarket', <String, dynamic>{
        'packageName': androidPackageName,
        'marketPackageName': androidMarketPackageName,
      });
    } else if (Platform.isIOS) {
      assert(iOSAppleId == null, 'Apple ID cannot be empty.');

      switch (jumpMode) {
        case JumpMode.detailPage:
          await _launchUrl('$detailPageUrl$iOSAppleId');
          break;
        case JumpMode.reviewsPage:
          await _launchUrl('$reviewsPageUrl$iOSAppleId');
          break;
        case JumpMode.writeReview:
          await _launchUrl('$detailPageUrl$iOSAppleId$writeReviewUrl');
          break;
      }
    } else {
      throw UnimplementedError('Only Android and iOS is currently supported.');
    }
  }

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
      throw UnimplementedError('Only iOS is currently supported.');
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
