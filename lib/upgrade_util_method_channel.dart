import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:upgrade_util/src/string.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'upgrade_util.dart';
import 'upgrade_util_platform_interface.dart';

/// An implementation of [UpgradeUtilPlatform] that uses method channels.
class MethodChannelUpgradeUtil extends UpgradeUtilPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel methodChannel =
      const MethodChannel('upgrade_util.io.channel/method');

  @override
  Future<String?> getPlatformVersion() async {
    final String? version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> openStore({
    String? packageName,
    IOSUpgradeOption? iOSOption,
  }) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // if (packageName.isBlank) {
      //   packageName =
      //       await methodChannel.invokeMethod<String>('getPackageName');
      // }
      // assert(!packageName.isBlank, 'The package name cannot be empty.');

      // await _launchUrl('market://details?id=$packageName');
      // await _launchUrl('market://details?id=$packageName');
      await _launchUrl(packageName ?? '');
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      assert(iOSOption != null, 'The IOSUpgradeOption cannot be empty.');
      await _launchUrl(iOSOption?.url);
    } else {
      const String details =
          'The `openStore` method of the upgrade_util plugin currently only '
          'supports Android and iOS.';
      throw PlatformException(code: 'Unimplemented', details: details);
    }
  }

  /// launch Url.
  Future<bool> _launchUrl(String? url) async {
    if (url == null || url.isBlank) return false;

    if (await canLaunchUrlString(url)) {
      return launchUrlString(url, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
