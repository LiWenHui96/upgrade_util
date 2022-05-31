import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upgrade_util/upgrade_util.dart';

import 'util_platform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // locale: const Locale('zh', 'CN'),
      // locale: const Locale('en', 'US'),
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        UpgradeLocalizationsDelegate.delegate,
      ],
      supportedLocales: <Locale>[Locale('en', 'US'), Locale('zh', 'CN')],
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> list = <String>[
    'Android Test: Get the download of apk',
    'Android Test: Get Available Market',
    'WeChat: Jump To AppStore Reviews Page',
    'WeChat: Jump To AppStore and Write Review',
    'WeChat: Jump To Detail Page',
    'WeChat: Upgrade Dialog',
  ];

  /// The app number of WeChat.
  final String wechatAppleID = '414478124';

  /// The package name of WeChat.
  final String wechatPackageName = 'com.tencent.mm';

  @override
  Widget build(BuildContext context) => _platformWidget();

  Widget _platformWidget() {
    Widget child = Center(
      child: Text('不支持【 ${PlatformUtil.operatingSystem} 】平台'),
    );

    if (Platform.isIOS || Platform.isAndroid) {
      child = _buildBodyWidget();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('App Upgrade Example')),
      body: child,
    );
  }

  Widget _buildBodyWidget() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final ElevatedButton child = ElevatedButton(
          onPressed: () async => onPressed(index),
          child: Text(list[index]),
        );

        return Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: child,
        );
      },
      itemCount: list.length,
    );
  }

  Future<void> onPressed(int index) async {
    switch (index) {
      case 0:
        final String result = await UpgradeUtil.getDownloadPath();
        debugPrint(result);
        break;
      case 1:
        // Get a list of all the app markets in the phone.
        final List<AndroidMarketModel> marketPackages =
            await UpgradeUtil.getMarkets(
          androidMarket: AndroidMarket.allTrue,
        );
        debugPrint(marketPackages.toString());
        break;
      case 2:
        // Jump to the AppStore review page, here we use WeChat as an example.
        await UpgradeUtil.jumpToStore(
          jumpMode: JumpMode.reviewsPage,
          appleId: wechatAppleID,
          packageName: wechatPackageName,
        );
        break;
      case 3:
        // Jump to AppStore and comment, here we use WeChat as an example.
        await UpgradeUtil.jumpToStore(
          jumpMode: JumpMode.writeReview,
          appleId: wechatAppleID,
          packageName: wechatPackageName,
        );
        break;
      case 4:
        // Jump to the details page, here we use WeChat as an example.
        await UpgradeUtil.jumpToStore(
          jumpMode: JumpMode.detailPage,
          appleId: wechatAppleID,
          packageName: wechatPackageName,
        );
        break;
      case 5:
        // Show update dialog, here we use WeChat as an example.
        await showUpgradeDialog<void>(
          context,
          upgradeConfig: UpgradeConfig(
            title: '发现新版本V8.8.8.414174360',
            content: '1.修复已知Bug\n2.优化软件性能，提升用户体验效果\n3.更多新功能等待您的探索',
          ),
          iOSUpgradeConfig: IosUpgradeConfig(appleId: wechatAppleID),
          androidUpgradeConfig: AndroidUpgradeConfig(
            packageName: wechatPackageName,
            androidMarket: AndroidMarket.allTrue,
          ),
        );
        break;
      default:
        break;
    }
  }
}
