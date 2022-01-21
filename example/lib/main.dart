import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upgrade_util/upgrade_util.dart';
import 'package:upgrade_util_example/page_android.dart';
import 'package:upgrade_util_example/page_ios.dart';

import 'util_platform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // locale: const Locale('zh', 'CN'),
      // locale: const Locale('en', 'US'),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        UpgradeLocalizationsDelegate.delegate,
      ],
      supportedLocales: const [Locale('en', 'US'), Locale('zh', 'CN')],
      home: const HomePage(),
      routes: {
        '/iOSUpgradePage': (context) => const PageIOS(),
        '/AndroidUpgradePage': (context) => const PageAndroid(),
      },
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
  @override
  Widget build(context) => _platformWidget();

  Widget _platformWidget() {
    Widget child = Text('不支持【 ${PlatformUtil.operatingSystem} 】平台');

    if (Platform.isIOS || Platform.isAndroid) {
      child = ElevatedButton(
        onPressed: () async => Navigator.pushNamed(context, pageName),
        child: const Text('To Upgrade Page'),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(child: child),
    );
  }

  String get pageName {
    if (Platform.isIOS) {
      return '/iOSUpgradePage';
    } else if (Platform.isAndroid) {
      return '/AndroidUpgradePage';
    } else {
      return '';
    }
  }
}
