import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upgrade_util/upgrade_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The app number of WeChat.
  final String wechatAppleID = '414478124';

  @override
  void initState() {
    super.initState();
  }

  /// 以微信为例，跳转至 App Store。
  Future<void> _open(UpgradeOpenType type) async {
    try {
      await UpgradeUtil.launch(type: type, appleID: wechatAppleID);
    } on PlatformException catch (e) {
      debugPrint('Failed to open ${type.name}: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = Column(
      crossAxisAlignment: .stretch,
      spacing: 12,
      children: <Widget>[
        ElevatedButton(onPressed: () => _open(.detail), child: const Text('详情页')),
        if (Platform.isIOS) ElevatedButton(onPressed: () => _open(.reviews), child: const Text('评论列表页')),
        ElevatedButton(onPressed: () => _open(.review), child: const Text('写评论')),
      ],
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Padding(
          padding: const .symmetric(horizontal: 12),
          child: SingleChildScrollView(child: child),
        ),
      ),
    );
  }
}
