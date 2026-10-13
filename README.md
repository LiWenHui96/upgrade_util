# Flutter Upgrade Util

[![pub package](https://img.shields.io/pub/v/upgrade_util)](https://pub.dev/packages/upgrade_util)
[![GitHub license](https://img.shields.io/github/license/LiWenHui96/upgrade_util?label=协议&style=flat-square)](https://github.com/LiWenHui96/upgrade_util/blob/master/LICENSE)

Language: [中文](README-ZH.md) | English

An in-app update plugin: jump to the app store detail page, the review list page, or the write-review page. At present, the plugin supports Android and iOS.

## Preparing for use

### Version constraints

```yaml
  sdk: ^3.11.0
  flutter: ">=3.41.0"
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

### UpgradeOpenType

The target page type, passed as `type` to `launch`.

| Value     | Description       | Platform                                                                                                                                        |
|-----------|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| `detail`  | App detail page   | Android, iOS                                                                                                                                    |
| `reviews` | Review list page  | iOS only; throws `UnsupportedError` on Android                                                                                                  |
| `review`  | Write-review page | Android, iOS. On Android only OPPO (incl. realme/OnePlus), vivo and Honor support review deep links; other markets fall back to the detail page |

### launch

```dart
Future<bool> UpgradeUtil.launch({
  required UpgradeOpenType type,
  String? packageName,
  String? appleID,
})
```

| Name        | Type              | Description                                                                                          | Default    |
|-------------|-------------------|------------------------------------------------------------------------------------------------------|------------|
| type        | `UpgradeOpenType` | Target page type                                                                                     | `required` |
| packageName | `String?`         | Target app package name. Android only; defaults to the host app's package name. Ignored on iOS.      | `null`     |
| appleID     | `String?`         | The app's Apple ID. Required on iOS (an `ArgumentError` is thrown when missing). Ignored on Android. | `null`     |

Returns whether the jump was successfully initiated. On iOS the value comes from the system callback; on Android it only indicates that the target page could be opened, and does not cover the user's subsequent actions in the market.

The Apple ID can be found in [App Store Connect](https://appstoreconnect.apple.com) → My Apps → select the app → "App Information" → "Apple ID", or taken from the digits after `id` in the App Store link `https://apps.apple.com/app/id<AppleID>`.

### Platform behavior

**Android**

- The plugin automatically detects the installed vendor app market (priority: Huawei, Honor, Xiaomi, OPPO, vivo, Meizu, Samsung) and launches it with the brand-specific scheme; markets without a dedicated scheme use the generic `market://` protocol.
- Write-review deep links are supported by OPPO (incl. realme, OnePlus), vivo, and Honor (market versionCode ≥ 160036301); on other markets `review` falls back to the detail page.

**iOS**

- Builds `itms-apps://` App Store links for the detail page, review list page, and write-review page.

## Example

```dart
// Open WeChat's detail page in the app store.
final bool opened = await UpgradeUtil.launch(
  type: UpgradeOpenType.detail,
  packageName: 'com.tencent.mm', // Android
  appleID: '414478124',          // iOS
);
```

See [example/lib/main.dart](example/lib/main.dart) for a complete example.

> If you like my project, please in the upper right corner of the project "Star". Your support is my biggest encouragement! ^_^