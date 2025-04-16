# Flutter Upgrade Util

[![pub package](https://img.shields.io/pub/v/upgrade_util)](https://pub.dev/packages/upgrade_util)
[![GitHub license](https://img.shields.io/github/license/LiWenHui96/upgrade_util?label=协议&style=flat-square)](https://github.com/LiWenHui96/upgrade_util/blob/master/LICENSE)

Language: [中文](README-ZH.md) | English

At present, the plugin is only used by Android, iOS.

## Preparing for use

### Version constraints

```yaml
  sdk: ^3.5.0
  flutter: ">=3.24.0"
```

### Rely

1. Add `upgrade_util` to `pubspec.yaml` dependencies.

```yaml
dependencies:
  upgrade_util: ^latest_version
```

2. Get the package by executing the flutter command.

```
flutter pub get
```

3. Introduce

```dart
import 'package:upgrade_util/upgrade_util.dart';
```

## Usage

### UpgradeOption

Popups are implemented by using `UpgradeOption`.

| Name       | Type                    | Description       | Default |
|------------|-------------------------|-------------------|---------|
| parameters | `Map<String, dynamic>?` | Custom parameters | `null`  |

### IOSUpgradeOption

Popups are implemented by using `IOSUpgradeOption`.

| Name    | Type          | Description | Default    |
|---------|---------------|-------------|------------|
| appleId | `String?`     | Apple ID    | `required` |
| mode    | `IOSOpenMode` | Open Mode.  | `required` |

### AndroidUpgradeOption

Popups are implemented by using `AndroidUpgradeOption`.

| Name             | Type           | Description                  | Default    |
|------------------|----------------|------------------------------|------------|
| brand            | `AndroidBrand` | The brand.                   | `required` |
| packageName      | `String?`      | The package name.            | `null`     |
| link             | `String?`      | Custom link.                 | `null`     |
| isUseDownloadUrl | `bool`         | Whether to use download url. | `false`    |
| downloadUrl      | `String?`      | Download url.                | `null`     |

## Method

To jump to the App Store or the application market, use the `openStore` method

> If you like my project, please in the upper right corner of the project "Star". Your support is my biggest encouragement! ^_^
