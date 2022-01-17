import 'dart:io';

import 'package:flutter/foundation.dart';

///
/// @Author: LiWeNHuI
/// @Date: 2022/01/13
///

class PlatformUtil {
  /// Operating system description
  static String get operatingSystem {
    if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else if (Platform.isWindows) {
      return 'Windows';
    } else if (Platform.isMacOS) {
      return 'macOS';
    } else if (Platform.isLinux) {
      return 'Linux';
    } else if (Platform.isFuchsia) {
      return 'Fuchsia OS';
    } else if (kIsWeb) {
      return 'Web';
    }

    return '';
  }
}
