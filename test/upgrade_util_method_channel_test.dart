import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upgrade_util/upgrade_util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MethodChannelUpgradeUtil platform = MethodChannelUpgradeUtil();
  const MethodChannel channel = MethodChannel('upgrade_util');

  /// 以微信的 Apple ID 为例。
  const String appleID = '414478124';

  /// 记录所有经过通道的调用。
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      MethodCall methodCall,
    ) async {
      log.add(methodCall);
      return true;
    });
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  group('iOS', () {
    setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.iOS);

    test('open detail opens the App Store detail page', () async {
      await platform.open(type: .detail, appleID: appleID);

      expect(log, hasLength(1));
      expect(log.single.method, 'open');
      expect(log.single.arguments, <String, String>{'url': 'itms-apps://apps.apple.com/app/id$appleID'});
    });

    test('open reviews opens the App Store reviews page', () async {
      await platform.open(type: .reviews, appleID: appleID);

      expect(log, hasLength(1));
      expect(log.single.method, 'open');
      expect(log.single.arguments, <String, String>{
        'url':
            'itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews'
            '?id=$appleID&type=Purple+Software',
      });
    });

    test('open review opens the App Store write-review page', () async {
      await platform.open(type: .review, appleID: appleID);

      expect(log, hasLength(1));
      expect(log.single.method, 'open');
      expect(log.single.arguments, <String, String>{
        'url': 'itms-apps://apps.apple.com/app/id$appleID?action=write-review',
      });
    });

    test('open ignores packageName on iOS', () async {
      await platform.open(type: .detail, packageName: 'com.tencent.xin', appleID: appleID);

      expect(log, hasLength(1));
      expect(log.single.arguments, <String, String>{'url': 'itms-apps://apps.apple.com/app/id$appleID'});
    });

    test('open without appleID throws ArgumentError', () async {
      await expectLater(platform.open(type: .detail), throwsArgumentError);
      expect(log, isEmpty);
    });

    test('open with an empty appleID throws ArgumentError', () async {
      await expectLater(platform.open(type: .detail, appleID: ''), throwsArgumentError);
      expect(log, isEmpty);
    });
  });

  group('Android', () {
    setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.android);

    // 当前 Android 分支尚未接入原生通道，仅断言调用可以正常完成。
    test('open detail completes', () async {
      await expectLater(platform.open(type: .detail), completes);
    });

    test('open with packageName completes', () async {
      await expectLater(platform.open(type: .detail, packageName: 'com.example.app'), completes);
    });
  });

  group('unsupported platforms', () {
    setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.linux);

    test('open detail throws UnsupportedError', () async {
      await expectLater(platform.open(type: .detail, appleID: appleID), throwsUnsupportedError);
      expect(log, isEmpty);
    });

    test('open review throws UnsupportedError', () async {
      await expectLater(platform.open(type: .review, appleID: appleID), throwsUnsupportedError);
      expect(log, isEmpty);
    });
  });
}
