import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:upgrade_util_example/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('upgrade_util');

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
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  testWidgets('renders the launch buttons and the initial message', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('详情页'), findsOneWidget);
    expect(find.text('写评论'), findsOneWidget);
    // 评论列表页仅 iOS 展示，测试宿主平台非 iOS。
    expect(find.text('评论列表页'), findsNothing);
  });

  testWidgets('tapping detail launches the market detail page and shows the result', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('详情页'));
    await tester.pump();

    expect(log, hasLength(1));
    expect(log.single.method, 'launchDetail');
    expect(log.single.arguments, <String, String?>{'packageName': 'com.tencent.mm'});
    expect(find.text('已打开微信详情页'), findsOneWidget);
  });

  testWidgets('tapping review shows a failure message when the page cannot be opened', (WidgetTester tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      MethodCall methodCall,
    ) async {
      log.add(methodCall);
      return false;
    });

    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('写评论'));
    await tester.pump();

    expect(log, hasLength(1));
    expect(log.single.method, 'launchReview');
    expect(find.text('未能打开微信写评论页'), findsOneWidget);
  });
}
