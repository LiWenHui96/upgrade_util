import 'dart:io';

import 'package:flutter/material.dart';
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
  /// 示例目标应用「微信」在各商店的标识。
  static const String _appleID = '414478124';
  static const String _packageName = 'com.tencent.mm';

  /// 最近一次跳转的结果提示。
  String _message = '以微信为例，点击下方按钮跳转应用商店';

  /// 跳转至应用商店，并展示原生侧返回的打开结果。
  Future<void> _launch(UpgradeOpenType type) async {
    final String label = switch (type) {
      .detail => '详情页',
      .reviews => '评论列表页',
      .review => '写评论页',
    };
    try {
      final bool opened = await UpgradeUtil.launch(type: type, packageName: _packageName, appleID: _appleID);
      setState(() => _message = opened ? '已打开微信$label' : '未能打开微信$label');
    } on Exception catch (e) {
      setState(() => _message = '打开微信$label失败：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = Column(
      crossAxisAlignment: .stretch,
      spacing: 12,
      children: <Widget>[
        Text(_message, textAlign: .center),
        ElevatedButton(onPressed: () => _launch(.detail), child: const Text('详情页')),
        // 评论列表页仅 iOS 支持。
        if (Platform.isIOS) ElevatedButton(onPressed: () => _launch(.reviews), child: const Text('评论列表页')),
        ElevatedButton(onPressed: () => _launch(.review), child: const Text('写评论')),
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
