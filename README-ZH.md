# upgrade_util

[![pub package](https://img.shields.io/pub/v/upgrade_util)](https://pub.dev/packages/upgrade_util)
[![GitHub license](https://img.shields.io/github/license/LiWenHui96/upgrade_util?label=协议&style=flat-square)](https://github.com/LiWenHui96/upgrade_util/blob/master/LICENSE)

Language: 中文 | [English](README.md)

> Flutter 应用内更新插件：跳转应用商店的**详情页**、**评论列表页**与**写评论页**。支持 **Android** 与 **iOS**。

Android 端自动检测本机已安装的厂商应用市场（华为、荣耀、小米、OPPO、vivo、魅族、三星），并使用品牌专属协议唤起，未收录品牌协议的市场回退至 `market://` 通用协议；iOS 端通过 `itms-apps://` 链接打开 App Store 的详情页、评论列表页与写评论页。

## 环境要求

```yaml
  sdk: ^3.11.0
  flutter: ">=3.41.0"
```

## 快速开始

### 第一步：添加依赖

将 `upgrade_util` 添加至 `pubspec.yaml` 引用：

```yaml
dependencies:
  upgrade_util: ^latest_version
```

```dart
import 'package:upgrade_util/upgrade_util.dart';
```

### 第二步：获取 Apple ID（iOS）

`appleID` 在 iOS 端必传。获取方式：[App Store Connect](https://appstoreconnect.apple.com) →
我的 App → 选择对应 App → **「App 信息」中的「Apple ID」**；也可从 App Store 链接
`https://apps.apple.com/app/id<AppleID>` 中 `id` 后的数字部分获取。

## 使用方法

### 跳转商店详情页

```dart
final bool opened = await UpgradeUtil.launch(
  type: UpgradeOpenType.detail,
  packageName: 'com.tencent.mm', // Android；不传时默认使用本应用包名
  appleID: '414478124',          // iOS
);
```

### 跳转写评论页

```dart
final bool opened = await UpgradeUtil.launch(
  type: UpgradeOpenType.review,
  appleID: '414478124',
);
```

> Android 端仅 OPPO（含 realme、一加）、vivo、荣耀支持评论深链，其他市场 `review` 回退至详情页。

### 跳转评论列表页（仅 iOS）

```dart
final bool opened = await UpgradeUtil.launch(
  type: UpgradeOpenType.reviews,
  appleID: '414478124',
);
```

> Android 端调用会在发起平台调用前抛出 `UnsupportedError`。

返回的 `bool` 表示是否成功发起跳转：iOS 端由系统回调给出；Android 端以能否唤起目标页面为准，不含用户在市场内的后续操作。

## 参数说明

### 方法

| 方法名      | 签名                                                                                       | 描述                      |
|----------|------------------------------------------------------------------------------------------|-------------------------|
| `launch` | `({required UpgradeOpenType type, String? packageName, String? appleID}) → Future<bool>` | 跳转目标应用商店页面，并返回是否成功发起跳转。 |

### `launch` 参数

| 参数名           | 类型                | 默认值      | 描述                                                              |
|---------------|-------------------|----------|-----------------------------------------------------------------|
| `type`        | `UpgradeOpenType` | required | 目标页面类型。                                                         |
| `packageName` | `String?`         | `null`   | 目标应用包名。**仅 Android**；不传时默认使用本应用包名。iOS 忽略该参数。                    |
| `appleID`     | `String?`         | `null`   | App 的 Apple ID。**iOS 必传**（未传时抛出 `ArgumentError`）。Android 忽略该参数。 |

### `UpgradeOpenType`

| 值         | 描述    | 平台                                                                |
|-----------|-------|-------------------------------------------------------------------|
| `detail`  | 应用详情页 | Android、iOS                                                       |
| `reviews` | 评论列表页 | 仅 iOS；Android 端调用抛出 `UnsupportedError`                            |
| `review`  | 写评论页  | Android、iOS。Android 端仅 OPPO（含 realme、一加）、vivo、荣耀支持评论深链，其他市场回退至详情页 |

## 注意事项

- **Android 市场检测**：按优先级依次匹配已安装的厂商市场——华为、荣耀、小米、OPPO、vivo、魅族、三星——首个已安装的市场生效；未收录品牌协议的市场使用 `market://` 通用协议唤起。
- **评论深链限制（Android）**：OPPO（含 realme、一加）、vivo、荣耀（市场 versionCode ≥ 160036301）支持写评论深链；其他市场 `review` 回退至详情页。
- **示例工程**：完整示例见 [example/lib/main.dart](example/lib/main.dart)。

> 如果你喜欢我的项目，请在项目右上角 "Star" 一下。你的支持是我最大的鼓励！ ^_^