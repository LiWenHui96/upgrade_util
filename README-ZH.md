# Flutter Upgrade Util

[![pub package](https://img.shields.io/pub/v/upgrade_util)](https://pub.dev/packages/upgrade_util)
[![GitHub license](https://img.shields.io/github/license/LiWenHui96/upgrade_util?label=协议&style=flat-square)](https://github.com/LiWenHui96/upgrade_util/blob/master/LICENSE)

Language: 中文 | [English](README.md)

应用内更新插件：跳转应用商店的详情页、评论列表页与写评论页。目前该插件仅适用于 Android，iOS。

## 准备工作

### 版本限制

```yaml
  sdk: ^3.11.0
  flutter: ">=3.41.0"
```

### 添加依赖

1. 将 `upgrade_util` 添加至 `pubspec.yaml` 引用

```yaml
dependencies:
  upgrade_util: ^latest_version
```

2. 执行flutter命令获取包

```
flutter pub get
```

3. 引入

```dart
import 'package:upgrade_util/upgrade_util.dart';
```

## 使用方法

### UpgradeOpenType

目标页面类型，作为 `type` 参数传递给 `launch`。

| 值         | 描述    | 平台                                                                |
|-----------|-------|-------------------------------------------------------------------|
| `detail`  | 应用详情页 | Android、iOS                                                       |
| `reviews` | 评论列表页 | 仅 iOS；Android 端调用抛出 `UnsupportedError`                            |
| `review`  | 写评论页  | Android、iOS。Android 端仅 OPPO（含 realme、一加）、vivo、荣耀支持评论深链，其他市场回退至详情页 |

### launch

```dart
Future<bool> UpgradeUtil.launch({
  required UpgradeOpenType type,
  String? packageName,
  String? appleID,
})
```

| 参数名         | 类型                | 描述                                                         | 默认值        |
|-------------|-------------------|------------------------------------------------------------|------------|
| type        | `UpgradeOpenType` | 目标页面类型                                                     | `required` |
| packageName | `String?`         | 目标应用包名，仅 Android 使用；不传时默认使用本应用包名。iOS 忽略该参数                 | `null`     |
| appleID     | `String?`         | App 的 Apple ID，iOS 必传（未传时抛出 `ArgumentError`）。Android 忽略该参数 | `null`     |

返回是否成功发起跳转。iOS 端由系统回调给出；Android 端以能否唤起目标页面为准，不含用户在市场内的后续操作。

Apple ID 获取方式：[App Store Connect](https://appstoreconnect.apple.com) → 我的 App → 选择对应 App → 「App 信息」中的「Apple ID」；也可从 App Store 链接 `https://apps.apple.com/app/id<AppleID>` 中 `id` 后的数字部分获取。

### 平台行为

**Android**

- 插件自动检测本机已安装的厂商应用市场（优先级：华为、荣耀、小米、OPPO、vivo、魅族、三星），并使用品牌专属协议唤起；未收录品牌协议的市场使用 `market://` 通用协议。
- 写评论深链支持 OPPO（含 realme、一加）、vivo、荣耀（市场 versionCode ≥ 160036301）；其他市场 `review` 回退至详情页。

**iOS**

- 通过 `itms-apps://` 链接打开 App Store 的详情页、评论列表页与写评论页。

## 示例

```dart
// 以微信为例，跳转应用商店详情页。
final bool opened = await UpgradeUtil.launch(
  type: UpgradeOpenType.detail,
  packageName: 'com.tencent.mm', // Android
  appleID: '414478124',          // iOS
);
```

完整示例见 [example/lib/main.dart](example/lib/main.dart)。

> 如果你喜欢我的项目，请在项目右上角 "Star" 一下。你的支持是我最大的鼓励！ ^_^