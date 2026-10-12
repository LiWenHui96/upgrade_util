import 'package:flutter_test/flutter_test.dart';
import 'package:upgrade_util/upgrade_util.dart';

/// 记录 [launch] 调用参数的伪实现。
class _FakeUpgradeUtilPlatform extends UpgradeUtilPlatform {
  int callCount = 0;
  UpgradeOpenType? type;
  String? packageName;
  String? appleID;

  @override
  Future<void> launch({required UpgradeOpenType type, String? packageName, String? appleID}) async {
    callCount++;
    this.type = type;
    this.packageName = packageName;
    this.appleID = appleID;
  }
}

/// 未重写 [launch] 的实现，用于验证基类的默认行为。
class _UnimplementedUpgradeUtilPlatform extends UpgradeUtilPlatform {}

void main() {
  final UpgradeUtilPlatform initialPlatform = UpgradeUtilPlatform.instance;

  tearDown(() => UpgradeUtilPlatform.instance = initialPlatform);

  test('$MethodChannelUpgradeUtil is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUpgradeUtil>());
  });

  test('launch throws UnimplementedError by default', () {
    expect(() => _UnimplementedUpgradeUtilPlatform().launch(type: UpgradeOpenType.detail), throwsUnimplementedError);
  });

  test('UpgradeUtil.launch delegates to UpgradeUtilPlatform.instance', () async {
    final _FakeUpgradeUtilPlatform fake = _FakeUpgradeUtilPlatform();
    UpgradeUtilPlatform.instance = fake;

    await UpgradeUtil.launch(type: .review, packageName: 'com.tencent.xin', appleID: '414478124');

    expect(fake.callCount, 1);
    expect(fake.type, UpgradeOpenType.review);
    expect(fake.packageName, 'com.tencent.xin');
    expect(fake.appleID, '414478124');
  });

  test('UpgradeUtil.launch forwards omitted optional arguments as null', () async {
    final _FakeUpgradeUtilPlatform fake = _FakeUpgradeUtilPlatform();
    UpgradeUtilPlatform.instance = fake;

    await UpgradeUtil.launch(type: .detail);

    expect(fake.callCount, 1);
    expect(fake.type, UpgradeOpenType.detail);
    expect(fake.packageName, isNull);
    expect(fake.appleID, isNull);
  });
}
