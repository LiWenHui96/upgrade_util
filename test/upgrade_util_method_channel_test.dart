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

    test('launch detail opens the App Store detail page', () async {
      final bool result = await platform.launch(type: .detail, appleID: appleID);

      expect(result, isTrue);
      expect(log, hasLength(1));
      expect(log.single.method, 'launch');
      expect(log.single.arguments, <String, String>{'url': 'itms-apps://apps.apple.com/app/id$appleID'});
    });

    test('launch reviews opens the App Store reviews page', () async {
      final bool result = await platform.launch(type: .reviews, appleID: appleID);

      expect(result, isTrue);
      expect(log, hasLength(1));
      expect(log.single.method, 'launch');
      expect(log.single.arguments, <String, String>{
        'url':
            'itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews'
            '?id=$appleID&type=Purple+Software',
      });
    });

    test('launch review opens the App Store write-review page', () async {
      final bool result = await platform.launch(type: .review, appleID: appleID);

      expect(result, isTrue);
      expect(log, hasLength(1));
      expect(log.single.method, 'launch');
      expect(log.single.arguments, <String, String>{
        'url': 'itms-apps://apps.apple.com/app/id$appleID?action=write-review',
      });
    });

    test('launch ignores packageName on iOS', () async {
      final bool result = await platform.launch(type: .detail, packageName: 'com.tencent.xin', appleID: appleID);

      expect(result, isTrue);
      expect(log, hasLength(1));
      expect(log.single.arguments, <String, String>{'url': 'itms-apps://apps.apple.com/app/id$appleID'});
    });

    test('launch returns false when the system fails to open the URL', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        MethodCall methodCall,
      ) async {
        log.add(methodCall);
        return false;
      });

      final bool result = await platform.launch(type: .detail, appleID: appleID);

      expect(result, isFalse);
      expect(log, hasLength(1));
    });

    test('launch returns false when the native side returns null', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        MethodCall methodCall,
      ) async {
        log.add(methodCall);
        return null;
      });

      final bool result = await platform.launch(type: .detail, appleID: appleID);

      expect(result, isFalse);
      expect(log, hasLength(1));
    });

    test('launch without appleID throws ArgumentError', () async {
      await expectLater(platform.launch(type: .detail), throwsArgumentError);
      expect(log, isEmpty);
    });

    test('launch with an empty appleID throws ArgumentError', () async {
      await expectLater(platform.launch(type: .detail, appleID: ''), throwsArgumentError);
      expect(log, isEmpty);
    });
  });

  group('Android', () {
    setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.android);

    test('launch detail opens the market detail page', () async {
      await platform.launch(type: .detail);

      expect(log, hasLength(1));
      expect(log.single.method, 'launchDetail');
      // packageName 缺省为 null，由原生端使用本应用包名。
      expect(log.single.arguments, <String, String?>{'packageName': null});
    });

    test('launch detail forwards packageName', () async {
      await platform.launch(type: .detail, packageName: 'com.example.app');

      expect(log, hasLength(1));
      expect(log.single.method, 'launchDetail');
      expect(log.single.arguments, <String, String?>{'packageName': 'com.example.app'});
    });

    test('launch review opens the market review page', () async {
      final bool result = await platform.launch(type: .review);

      expect(result, isTrue);
      expect(log, hasLength(1));
      expect(log.single.method, 'launchReview');
      // packageName 缺省为 null，由原生端使用本应用包名。
      expect(log.single.arguments, <String, String?>{'packageName': null});
    });

    test('launch review forwards packageName', () async {
      await platform.launch(type: .review, packageName: 'com.example.app');

      expect(log, hasLength(1));
      expect(log.single.method, 'launchReview');
      expect(log.single.arguments, <String, String?>{'packageName': 'com.example.app'});
    });

    test('launch review returns false when the native side fails to open', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        MethodCall methodCall,
      ) async {
        log.add(methodCall);
        return false;
      });

      final bool result = await platform.launch(type: .review);

      expect(result, isFalse);
      expect(log, hasLength(1));
    });

    test('launch reviews throws UnsupportedError', () async {
      await expectLater(platform.launch(type: .reviews), throwsUnsupportedError);
      expect(log, isEmpty);
    });
  });

  group('unsupported platforms', () {
    setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.linux);

    test('launch detail throws UnsupportedError', () async {
      await expectLater(platform.launch(type: .detail, appleID: appleID), throwsUnsupportedError);
      expect(log, isEmpty);
    });

    test('launch review throws UnsupportedError', () async {
      await expectLater(platform.launch(type: .review, appleID: appleID), throwsUnsupportedError);
      expect(log, isEmpty);
    });
  });
}
