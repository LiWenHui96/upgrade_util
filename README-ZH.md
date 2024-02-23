# Flutter Upgrade Util

[![pub package](https://img.shields.io/pub/v/upgrade_util)](https://pub.dev/packages/upgrade_util)
[![GitHub license](https://img.shields.io/github/license/LiWenHui96/upgrade_util?label=协议&style=flat-square)](https://github.com/LiWenHui96/upgrade_util/blob/master/LICENSE)

Language: 中文 | [English](README.md)

目前该插件仅适用于Android，iOS。

### 第三方使用

* 使用 `dio` 实现Android的apk下载，插件内已内置，无需引用；

## 准备工作

### 版本限制

```yaml
  sdk: ">=2.17.0 <3.0.0"
  flutter: ">=3.0.0"
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

### showUpgradeDialog

`showUpgradeDialog` 参数名及描述：

| 参数名                  | 类型                      | 描述          | 默认值                                                                                                                                                                              |
|----------------------|-------------------------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| context              | BuildContext            | 上下文         | 必填项                                                                                                                                                                              |
| key                  | `Key?`                  | 组件标识符       | `null`                                                                                                                                                                           |
| upgradeConfig        | `UpgradeConfig?`        | 弹窗样式        | `UpgradeConfig(title: UpgradeLocalizations.of(context).title, updateText: UpgradeLocalizations.of(context).updateText, cancelText: UpgradeLocalizations.of(context).cancelText)` |
| iOSUpgradeConfig     | `IosUpgradeConfig?`     | iOS升级信息     | `IosUpgradeConfig()`                                                                                                                                                             |
| androidUpgradeConfig | `AndroidUpgradeConfig?` | Android升级信息 | `AndroidUpgradeConfig(androidMarket: AndroidMarket(), downloadCancelText: UpgradeLocalizations.of(context).androidCancel)`                                                       |
| isDebugLog           | `bool`                  | 是否打印日志      | `false`                                                                                                                                                                          |
| barrierLabel         | `String?`               | 屏障标签        | `null`                                                                                                                                                                           |
| arguments            | `Object?`               | 传递参数        | `null`                                                                                                                                                                           |

### UpgradeConfig

`UpgradeConfig` 字段说明：

| 参数名               | 类型            | 描述                      | 默认值                                           |
|-------------------|---------------|-------------------------|-----------------------------------------------|
| force             | `bool`        | 是否为强制更新                 | `false`                                       |
| titleWidget       | `Widget?`     | 标题的布局。为空时，使用[Text]代替。   | `null`                                        |
| title             | `String?`     | 版本更新标题                  | `UpgradeLocalizations.of(context).title`      |
| titleTextStyle    | `TextStyle?`  | `title` 的文本样式           | `null`                                        |
| titleStrutStyle   | `StrutStyle?` | `title` 的支柱风格           | `null`                                        |
| titleWidget       | `Widget?`     | 更新内容的布局。为空时，使用[Text]代替。 | `null`                                        |
| content           | `String?`     | 版本更新内容                  | `null`                                        |
| contentTextStyle  | `TextStyle?`  | `content` 的文本样式         | `null`                                        |
| contentStrutStyle | `StrutStyle?` | `content ` 的支柱风格        | `null`                                        |
| updateText        | `String?`     | 升级按钮的文本                 | `UpgradeLocalizations.of(context).updateText` |
| updateTextStyle   | `TextStyle?`  | `updateText ` 的文本样式     | `null`                                        |
| cancelText        | `String?`     | 取消按钮的文本                 | `UpgradeLocalizations.of(context).cancelText` |
| cancelTextStyle   | `TextStyle?`  | `cancelText ` 的文本样式     | `null`                                        |

### IosUpgradeConfig

`IosUpgradeConfig` 字段说明：

| 参数名                        | 类型                  | 描述                        | 默认值     |
|----------------------------|---------------------|---------------------------|---------|
| appleId                    | `String?`           | Apple ID                  | `null`  |
| scrollController           | `ScrollController?` | 可用于控制对话框中“内容”滚动的滚动控制器     | `null`  |
| actionScrollController     | `ScrollController?` | 可用于控制对话框中操作滚动的滚动控制器       | `null`  |
| isUpgradeDefaultAction     | `bool`              | 如果升级按钮是对话框中的默认选项，则设置为true | `false` |
| isUpgradeDestructiveAction | `bool`              | 升级按钮的点击是否破坏了对象            | `false` |
| isCancelDefaultAction      | `bool`              | 如果取消按钮是对话框中的默认选项，则设置为true | `false` |
| isCancelDestructiveAction  | `bool`              | 取消按钮的点击是否破坏了对象            | `true`  |

### AndroidUpgradeConfig

`AndroidUpgradeConfig` 字段说明：

| 参数名                        | 类型                                                         | 描述                            | 默认值                                              |
|----------------------------|------------------------------------------------------------|-------------------------------|--------------------------------------------------|
| androidMarket              | `AndroidMarket?`                                           | Android应用市场配置                 | `AndroidMarket()`                                |
| otherMarkets               | `List<String>`                                             | 未在 `AndroidMarket` 内预置的应用市场包名 | `<String>[]`                                     |
| dialogBorderRadius         | `BorderRadius?`                                            | 弹窗的弧度                         | `BorderRadius.circular(10)`                      |
| topImageProvider           | `ImageProvider?`                                           | 弹窗顶部的图片                       | `null`                                           |
| topImageHeight             | `double?`                                                  | 弹窗顶部的图片的高度                    | `null`                                           |
| updateButton               | `Widget? Function(String label, VoidCallback? onPressed)?` | 升级按钮                          | `null`                                           |
| updateButtonStyle          | `ButtonStyle?`                                             | 升级按钮的样式                       | `null`                                           |
| downloadCancelText         | `String?`                                                  | 下载时的取消按钮的文本                   | `UpgradeLocalizations.of(context).androidCancel` |
| downloadUri                | `Uri?`                                                     | apk下载链接                       | `null`                                           |
| saveName                   | `String?`                                                  | apk文件保存名称                     | `temp.apk`                                       |
| downloadInterceptors       | `List<Interceptor>`                                        | [Dio] 中添加的拦截器                 | `<Interceptor>[]`                                |
| deleteOnError              | `bool`                                                     | 发生错误时是否删除文件                   | `true`                                           |
| lengthHeader               | `String`                                                   | 原始文件的实际大小（未压缩）                | `Headers.contentLengthHeader`                    |
| data                       | `dynamic`                                                  | 请求数据                          | `null`                                           |
| options                    | `Options?`                                                 | 每个请求都可以传递一个 [Options] 对象      | `null`                                           |
| isExistsFile               | `bool`                                                     | 验证是否存在文件。                     | `false`                                          |
| indicatorHeight            | `double?`                                                  | 下载时进度条的的高度                    | `10px`                                           |
| indicatorBackgroundColor   | `Color?`                                                   | 下载时进度条的背景色                    | `null`                                           |
| indicatorColor             | `Color?`                                                   | 下载时进度条的进度颜色                   | `null`                                           |
| indicatorValueColor        | `Color?`                                                   | 下载时进度条的进度颜色                   | `null`                                           |
| indicatorTextSize          | `double?`                                                  | 下载时进度条的文字大小                   | `8px`                                            |
| indicatorTextColor         | `Color?`                                                   | 下载时进度条的文字颜色                   | `null`                                           |
| onDownloadProgressCallback | `DownloadProgressCallback?`                                | 下载事件的进度监听                     | `null`                                           |
| onDownloadStatusCallback   | `DownloadStatusCallback?`                                  | 下载事件的状态监听                     | `null`                                           |

* `androidMarket` 应用市场详细配置可查看 [AndroidMarket](lib/src/android_market.dart)；
* `androidMarket` 与 `downloadUrl`，需配置其一；均配置的情况下，优先以 `androidMarket` 为主；

## 方法

跳转到 AppStore 或 应用市场，使用 `jumpToStore` 方法

* 必填项为 `jumpMode`，目前为止三种模式；
    1. `JumpMode.detailPage`，跳转到应用详情页面（即产品介绍页）；
    2. `JumpMode.reviewsPage`，跳转到应用评论页面；
    3. `JumpMode.writeReview`，跳转到应用评论页面并进行评论。
* `appleId` 为 iOS 的必填项，此为App Store的应用编号；
* `marketPackageName` 为 Android 跳转的应用市场的包名，非必填项。
* 不再提供 `packageName` 字段，因为统一使用项目的包名。

### Android 独有方法

1. `getDownloadPath` 获取apk下载的保存路径；
2. `installApk` 安装apk，跳转至安装引导页；
3. `getMarkets` 获取手机中包含的应用市场的软件信息的列表。

> 如果你喜欢我的项目，请在项目右上角 "Star" 一下。你的支持是我最大的鼓励！ ^_^
