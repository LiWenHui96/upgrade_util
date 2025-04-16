# Flutter Upgrade Util

[![pub package](https://img.shields.io/pub/v/upgrade_util)](https://pub.dev/packages/upgrade_util)
[![GitHub license](https://img.shields.io/github/license/LiWenHui96/upgrade_util?label=协议&style=flat-square)](https://github.com/LiWenHui96/upgrade_util/blob/master/LICENSE)

Language: 中文 | [English](README.md)

目前该插件仅适用于Android，iOS。

## 准备工作

### 版本限制

```yaml
  sdk: ^3.5.0
  flutter: ">=3.24.0"
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

### UpgradeOption

`UpgradeOption` 字段说明：

| 参数名     | 类型                    | 描述       | 默认值 |
|------------|-------------------------|------------|--------|
| parameters | `Map<String, dynamic>?` | 自定义参数 | `null` |

### IOSUpgradeOption

`IOSUpgradeOption` 字段说明：

| 参数名  | 类型          | 描述     | 默认值     |
|---------|---------------|----------|------------|
| appleId | `String`      | Apple ID | `required` |
| mode    | `IOSOpenMode` | 跳转方式 | `required` |

### AndroidUpgradeOption

`AndroidUpgradeConfig` 字段说明：

| 参数名           | 类型           | 描述                 | 默认值     |
|------------------|----------------|----------------------|------------|
| brand            | `AndroidBrand` | 手机品牌厂商         | `required` |
| packageName      | `String?`      | 应用包名             | `null`     |
| link             | `String?`      | 自定义链接           | `null`     |
| isUseDownloadUrl | `bool`         | 是否直接使用下载链接 | `false`    |
| downloadUrl      | `String?`      | 下载链接             | `null`     |

## 方法

跳转到 AppStore 或 应用市场，使用 `openStore` 方法

> 如果你喜欢我的项目，请在项目右上角 "Star" 一下。你的支持是我最大的鼓励！ ^_^
