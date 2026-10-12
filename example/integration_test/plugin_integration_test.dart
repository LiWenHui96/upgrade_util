// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:upgrade_util_example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('example app renders the store entry buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('详情页'), findsOneWidget);
    expect(find.text('写评论'), findsOneWidget);

    // 「评论列表页」按钮仅在 iOS 展示。
    expect(find.text('评论列表页'), Platform.isIOS ? findsOneWidget : findsNothing);
  });
}
