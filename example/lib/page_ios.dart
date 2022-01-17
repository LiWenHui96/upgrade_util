import 'package:flutter/material.dart';
import 'package:upgrade_util/upgrade_util.dart';

///
/// @Describe: iOS
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/12
///

class PageIOS extends StatefulWidget {
  const PageIOS({Key? key}) : super(key: key);

  @override
  _PageIOSState createState() => _PageIOSState();
}

class _PageIOSState extends State<PageIOS> {
  final list = <String>[
    'WeChat: Jump To AppStore Detail Page',
    'WeChat: Jump To AppStore Reviews Page',
    'WeChat: Jump To AppStore and Write Review',
    'WeChat: Update Dialog',
  ];

  /// The app number of WeChat.
  final wechatAppID = '414478124';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('iOS App Upgrade')),
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
        // Jump to the AppStore details page, here we use WeChat as an example.
        await UpgradeUtil.upgradeApp(appKey: wechatAppID);
        break;
      case 1:
        // Jump to the AppStore review page, here we use WeChat as an example.
        await IOSUpdateUtil.jumpToAppStore(
          eIOSJumpMode: EIOSJumpMode.reviewsPage,
          appId: wechatAppID,
        );
        break;
      case 2:
        // Jump to AppStore and comment, here we use WeChat as an example.
        await IOSUpdateUtil.jumpToAppStore(
          eIOSJumpMode: EIOSJumpMode.writeReview,
          appId: wechatAppID,
        );
        break;
      case 3:
        // Show update dialog, here we use WeChat as an example.
        final dialog = UpdateDialog<void>(
          context,
          appKey: wechatAppID,
          title: '发现新版本V8.8.8.414174360',
          content: '1.修复已知Bug\n2.优化软件性能，提升用户体验效果\n3.更多新功能等待您的探索',
        );
        await dialog.show();
        break;
      default:
        break;
    }
  }
}
