import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:upgrade_util/upgrade_util.dart';

/// @Describe: Upgrade function class
///
/// @Author: LiWeNHuI
/// @Date: 2022/2/23

class UpgradeUtil {
  static const MethodChannel _channel = MethodChannel(_channelName);

  /// Get the save path of the software download.
  ///
  /// This uses the `getCacheDir` API on the context.
  ///
  /// Use [softwareName] as the software name.
  /// It is `temp.apk` by default.
  static Future<String> getDownloadPath({String? softwareName}) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      throw PlatformException(
        code: 'Unimplemented',
        details:
            'The `getDownloadPath` method of the upgrade_util plugin currently '
            'only supports Android.',
      );
    }

    /// Data processing.
    softwareName ??= 'temp.apk';
    softwareName.replaceAll('.', '_');
    if (!softwareName.contains('.apk') && !softwareName.contains('.aab')) {
      throw ArgumentError('The softwareName must contain `.apk` or `.aab`');
    }

    final String? result = await _channel.invokeMethod('getDownloadPath');
    return '$result$softwareName';
  }

  /// Install apk.
  ///
  /// Jump to the installation page of the software.
  ///
  /// The [path] is the storage address of apk.
  static Future<bool?> installApk(String path) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      throw PlatformException(
        code: 'Unimplemented',
        details: 'The `installApk` method of the upgrade_util plugin currently '
            'only supports Android.',
      );
    }

    return _channel.invokeMethod('installApk', path);
  }

  /// Get a list of software information for the application market contained
  /// in the mobile phone
  ///
  /// When set to true, make sure your program is on the market.
  /// This plugin does not verify that your program is on the shelf.
  static Future<List<AndroidMarketModel>> getMarkets(
    List<String> packages,
  ) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      throw PlatformException(
        code: 'Unimplemented',
        details: 'The `getMarkets` method of the upgrade_util plugin currently '
            'only supports Android.',
      );
    }

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
  /// On iOS, the [appleId] is Apple ID.
  ///
  /// On Android, the [marketPackageName] is the package name of the
  /// application market to go to.
  static Future<void> jumpToStore({
    required JumpMode jumpMode,
    String? appleId,
    String? marketPackageName,
  }) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _channel.invokeMethod<void>('jumpToMarket', marketPackageName);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      assert(appleId != null, 'Apple ID cannot be empty.');

      switch (jumpMode) {
        case JumpMode.detailPage:
          await _launchUrl('$_detailPageUrl$appleId');
          break;
        case JumpMode.reviewsPage:
          await _launchUrl('$_reviewsPageUrl$appleId');
          break;
        case JumpMode.writeReview:
          await _launchUrl('$_detailPageUrl$appleId$_writeReviewUrl');
          break;
      }
    } else {
      throw PlatformException(
        code: 'Unimplemented',
        details:
            'The `jumpToStore` method of the upgrade_util plugin currently '
            'only supports Android and iOS.',
      );
    }
  }

  /// On iOS, implement link jump.
  static Future<bool?> _launchUrl(
    String url, {
    bool universalLinksOnly = false,
  }) async {
    // splicing url
    url += url.contains('?') ? '&' : '?';
    url += 'ls=1&mt=8';

    return _channel.invokeMethod('launch', <String, dynamic>{
      'url': url,
      'universalLinksOnly': universalLinksOnly,
    });
  }
}

/// iOS - Jump to the link address of the AppStore details page.
/// Another link: itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=
const String _detailPageUrl =
    'itms-apps://itunes.apple.com/cn/app/apple-store/id';

/// iOS - Jump to the link address of the AppStore review page
const String _reviewsPageUrl =
    'itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=';

/// iOS - The suffix of the link to jump to the AppStore and comment.
const String _writeReviewUrl = '?action=write-review';

/// MethodChannel's name
const String _channelName = 'upgrade_util.io.channel/method';

/// How to jump to the store's page
enum JumpMode {
  /// Product page
  detailPage,

  /// Evaluation page
  reviewsPage,

  /// Write an evaluation
  writeReview,
}
