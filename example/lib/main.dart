import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:upgrade_util/upgrade_util.dart';

void main() {
  runApp(const MyApp());
}

/// Program entry.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Home
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// The app number of WeChat.
  final String wechatAppleID = '414478124';

  /// The package name of WeChat.
  final String wechatPackageName = 'com.tencent.mm';

  @override
  Widget build(BuildContext context) {
    Widget child = Center(
      child: Text('不支持【 $operatingSystem 】平台'),
    );

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      List<Widget> children = <Widget>[];

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        children = _buildIOSBody;
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        children = _buildAndroidBody;
      }

      child = SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16)
            .add(EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom)),
        child: Column(
          children: children.map((Widget child) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              child: child,
            );
          }).toList(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('App Upgrade Example')),
      body: child,
    );
  }

  /// iOS body.
  List<Widget> get _buildIOSBody {
    Future<void> onPressed(IOSUpgradeOption option) async {
      await UpgradeUtil.openStore(iOSOption: option);
    }

    return <Widget>[
      ElevatedButton(
        onPressed: () async => onPressed(
          IOSUpgradeOption(appId: wechatAppleID, mode: IOSOpenMode.product),
        ),
        child: const Text('Open Product Page.'),
      ),
      ElevatedButton(
        onPressed: () async => onPressed(
          IOSUpgradeOption(appId: wechatAppleID, mode: IOSOpenMode.reviews),
        ),
        child: const Text('Open Reviews Page'),
      ),
      ElevatedButton(
        onPressed: () async => onPressed(
          IOSUpgradeOption(appId: wechatAppleID, mode: IOSOpenMode.writeReview),
        ),
        child: const Text('Open Reviews Page, and Write review.'),
      ),
    ];
  }

  /// Android body.
  List<Widget> get _buildAndroidBody {
    return <Widget>[
      ElevatedButton(
        // onPressed: () async => UpgradeUtil.openStore(
        //   packageName: wechatPackageName,
        // ),
        onPressed: () async => UpgradeUtil.openStore(
          packageName: 'appmarket://details?id=$wechatPackageName',
        ),
        // child: const Text('Open Product Page.'),
        child: const Text('华为'),
      ),
      ElevatedButton(
        onPressed: () async => UpgradeUtil.openStore(
          // packageName: 'mimarket://details?id=$wechatPackageName',
          // packageName: 'https://link.vvstc.com/index.html?id=$wechatPackageName',
          packageName: 'https://link.vvstc.com/index.html?id=cn.eol.kaoyan',
          // packageName: 'https://app.mi.com/details?id=$wechatPackageName',
        ),
        child: const Text('小米'),
      ),
      ElevatedButton(
        onPressed: () async => UpgradeUtil.openStore(
          packageName:
              'market://details?id=$wechatPackageName&caller=$wechatPackageName',
        ),
        child: const Text('OPPO'),
      ),
      ElevatedButton(
        onPressed: () async => UpgradeUtil.openStore(
          packageName:
              'vivomarket://details?id=$wechatPackageName&th_name=self_update&th_update_delay=1',
        ),
        child: const Text('vivo'),
      ),
      ElevatedButton(
        onPressed: () async => UpgradeUtil.openStore(
          packageName: 'market://details?id=$wechatPackageName',
        ),
        child: const Text('荣耀'),
      ),
    ];
  }

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
