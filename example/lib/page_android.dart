import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:upgrade_util/upgrade_util.dart';

/// @Describe: Android
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/13

class PageAndroid extends StatefulWidget {
  const PageAndroid({Key? key}) : super(key: key);

  @override
  _PageAndroidState createState() => _PageAndroidState();
}

class _PageAndroidState extends State<PageAndroid> {
  final list = <String>[
    'Test: Get the download of apk',
    'Test: Get Available Market',
    'WeChat: Jump To AppMarket Detail Page',
    'WeChat: Upgrade Dialog',
  ];

  final wechatPackageName = 'com.tencent.mm';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Android App Upgrade')),
      body: _buildBodyWidget(),
    );
  }

  Widget _buildBodyWidget() {
    return ListView.builder(
      itemBuilder: (context, index) {
        final child = ElevatedButton(
          onPressed: () async => onPressed(index),
          child: Text(list[index]),
        );

        return Container(
          margin: const EdgeInsets.only(top: 10.0),
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: child,
        );
      },
      itemCount: list.length,
    );
  }

  Future onPressed(int index) async {
    switch (index) {
      case 0:
        final result = await AndroidUtil.getDownloadPath(apkName: 'app.apk');
        debugPrint(result);
        break;
      case 1:
        // Jump to the AppStore details page, here we use WeChat as an example.
        final marketPackages = await AndroidUtil.getAvailableMarket(
            androidMarket: AndroidMarket.allTrue);
        debugPrint(marketPackages.toString());
        break;
      case 2:
        await AndroidUtil.jumpToMarket(packageName: wechatPackageName);
        break;
      case 3:
        // Show update dialog, here we use WeChat as an example.
        await UpgradeDialog.show<void>(
          context,
          appKey: wechatPackageName,
          androidMarket: AndroidMarket.allTrue,
          title: '发现新版本V8.8.8.414174360',
          content: '1.修复已知Bug\n2.优化软件性能，提升用户体验效果\n3.更多新功能等待您的探索',
        );
        break;
      default:
        break;
    }
  }
}
