# Flutter Upgrade Util

[![pub package](https://img.shields.io/pub/v/upgrade_util)](https://pub.dev/packages/upgrade_util)
[![GitHub license](https://img.shields.io/github/license/LiWenHui96/upgrade_util?label=协议&style=flat-square)](https://github.com/LiWenHui96/upgrade_util/blob/master/LICENSE)

Language: 中文 | [English](README.md)

目前该插件仅适用于Android，iOS

### 第三方使用

* 使用 `dio` 实现Android的apk下载；
* 使用 `url_launcher_ios` 实现iOS的链接跳转。

## 准备工作

### 版本限制

```yaml
  sdk: ">=2.14.0 <3.0.0"
  flutter: ">=2.5.0"
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

### 本地化配置

在 `MaterialApp` 添加

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ...
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        ...
        UpgradeLocalizationsDelegate.delegate,
      ],
      ...
    );
  }
}
```

## 使用方法

弹窗使用 `CupertinoAlertDialog` 实现。

`UpgradeDialog` 参数名及描述：

| 参数名 | 类型 | 描述 | 默认值 |
| --- | --- | --- | --- |
| key | `Key?` | 组件标识符 | `ObjectKey(context)` |
| appKey | `String` | Android应用包名；iOS应用商店编号 | 必填项 |
| androidMarket | `AndroidMarket?` | Android应用市场配置 | `AndroidMarket()` |
| otherMarkets | `List<String>?` | 未在 `AndroidMarket` 内预置的应用市场包名 | `null` |
| downloadUrl | `String?` | apk下载链接 | ` ` |
| saveApkName | `String?` | apk文件保存名称 | `temp` |
| savePrefixName | `String?` | apk文件保存的文件夹 | `libCacheApkDownload` |
| title | `String?` | 标题 | `UpgradeLocalizations.of(context).title` |
| content | `String?` | 版本新增内容 | `UpgradeLocalizations.of(context).content` |
| contentTextAlign | `TextAlign` | `content` 对齐方式 | `TextAlign.start` |
| scrollController | `ScrollController?` | `CupertinoAlertDialog.scrollController` | `null` |
| actionScrollController | `ScrollController?` | `CupertinoAlertDialog.actionScrollController` | `null` |
| force | `bool` | 是否为强制更新 | `false` |
| updateKey | `Key?` | 确定（升级）按钮的组件标识符 | `null` |
| updateText | `String?` | 确定（升级）按钮的文字显示 | `UpgradeLocalizations.of(context).updateText` |
| updateTextStyle | `TextStyle?` | 确定（升级）按钮的文字风格 | `null` |
| isUpgradeDefaultAction | `bool` | 确定（升级）按钮是否为默认选项 | `false` |
| isUpgradeDestructiveAction | `bool` | 确定（升级）按钮是否为销毁操作 | `false` |
| cancelKey | `Key?` | 取消按钮的组件标识符 | `null` |
| cancelText | `String?` | 取消按钮的文字显示 | `UpgradeLocalizations.of(context).cancelText` |
| cancelTextStyle | `TextStyle?` | 取消按钮的文字风格 | `null` |
| isCancelDefaultAction | `bool` | 取消按钮是否为默认选项 | `false` |
| isCancelDestructiveAction | `bool` | 取消按钮是否为销毁操作 | `true` |
| updateCallback | `VoidCallback?` | 确定（升级）按钮的点击事件监听 | `null` |
| cancelCallback | `VoidCallback?` | 取消按钮的点击事件监听 | `null` |
| downloadProgressCallback | `DownloadProgressCallback?` | 下载事件的进度监听 | `null` |
| downloadStatusCallback | `DownloadStatusCallback?` | 下载事件的状态监听 | `null` |

### iOS

* `appKey` 为App Store的应用编号，请确保应用是已发布并为上架状态；
* `androidMarket`，`otherMarkets`，`downloadUrl`，`saveApkName`，`savePrefixName`，`downloadProgressCallback`，`downloadStatusCallback`，在iOS平台是无效的。

### Android

* `appKey` 为应用包名；
* `androidMarket` 应用市场详细配置可查看 [AndroidMarket](lib/src/android/android_market.dart)；
* `androidMarket` 与 `downloadUrl`，需配置其一；均配置的情况下，优先以 `androidMarket` 为主；
* `saveApkName` 无须携带后缀，默认设置为 `.apk`；
* `savePrefixName` 无须拼接 `/`，默认配置为 `/${savePrefixName}/`。

## 方法

### iOS

跳转到App Store，使用 `jumpToAppStore` 方法

* 必填项为 `appId`，此为App Store的应用编号；
* 分三种模式

    1. `EIOSJumpMode.detailPage`，跳转到应用详情页面（即产品介绍页）；
    2. `EIOSJumpMode.reviewsPage`，跳转到应用评论页面；
    3. `EIOSJumpMode.writeReview`，跳转到应用评论页面并进行评论。

### Android

1. `getDownloadPath` 获取apk下载地址；
2. `installApk` 安装apk，跳转至安装引导页；
3. `getAvailableMarket` 获取当前可用的应用市场；
4. `jumpToMarket` 跳转到应用市场的应用详情页面。

