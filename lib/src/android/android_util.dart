import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:upgrade_util/upgrade_util.dart';

/// @Describe: Android upgrade function class
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/17

class AndroidUtil {
  static const _channel = MethodChannel('upgrade_util');

  /// Method - Android - Get the download path of x.apk.
  ///
  /// This uses the `getCacheDir` API on the context.
  /// It is `/data/data/xx.xx.xx/cache` by default.
  ///
  /// The [apkName] is the saved name of apk.
  ///
  /// The [prefixName] is intermediate folder.
  static Future<String> getDownloadPath({
    String? apkName,
    String? prefixName,
  }) async {
    apkName = '${apkName ?? 'temp'}.apk';
    prefixName = '/${prefixName ?? 'libCacheApkDownload'}/';

    final result = await _channel.invokeMethod<String>('getApkDownloadPath');
    return '$result$prefixName$apkName';
  }

  /// Method - Android - Install apk.
  ///
  /// Jump to APK installation boot page.
  ///
  /// The [path] is the storage address of apk.
  static Future<bool> installApk(String path) async {
    final map = {'path': path};
    return await _channel.invokeMethod<bool>('installApk', map) ?? false;
  }

  /// Method - Android - Gets the package name of the available market.
  ///
  /// When set to true, make sure your program is on the market.
  /// This plug-in does not verify that your program is on the shelf.
  static Future<List<AndroidMarketModel>> getAvailableMarket({
    AndroidMarket? androidMarket,
    List<String>? otherMarkets,
  }) async {
    final list = (androidMarket ?? AndroidMarket()).toMarkets();
    list.addAll(otherMarkets ?? <String>[]);
    final map = {'packages': list};
    final result = await _channel.invokeMethod<List>('availableMarket', map);
    final jsonData = json.decode(json.encode(result)) as List;
    final jsonResult = jsonData
        .map<Map<String, dynamic>>((dynamic e) => e as Map<String, dynamic>)
        .toList();
    return jsonResult.map((e) => AndroidMarketModel.fromJson(e)).toList();
  }

  /// Method - Android - Jump to the details page of App Market.
  ///
  /// The [packageName] is package name.
  ///
  /// The [marketPackageName] is the package name of market.
  static Future jumpToMarket({
    required String packageName,
    String? marketPackageName,
  }) async {
    final map = {
      'packageName': packageName,
      'marketPackageName': marketPackageName,
    };
    await _channel.invokeMethod<void>('jumpToMarket', map);
  }
}
