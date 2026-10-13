# upgrade_util

[![pub package](https://img.shields.io/pub/v/upgrade_util)](https://pub.dev/packages/upgrade_util)
[![GitHub license](https://img.shields.io/github/license/LiWenHui96/upgrade_util?label=License&style=flat-square)](https://github.com/LiWenHui96/upgrade_util/blob/master/LICENSE)

Language: [中文](README-ZH.md) | English

> A Flutter plugin for in-app updates: jump to the app store **detail page**, **review
> list page**, or **write-review page**. Supports **Android** and **iOS**.

On Android the plugin automatically detects the installed vendor app market (Huawei, Honor,
Xiaomi, OPPO, vivo, Meizu, Samsung) and launches it with the brand-specific scheme, falling back
to the generic `market://` protocol for unlisted markets; on iOS it builds `itms-apps://` App
Store links for the detail page, the review list page, and the write-review page.

## Requirements

```yaml
  sdk: ^3.11.0
  flutter: ">=3.41.0"
```

## Getting started

### Step 1: Add the dependency

Add `upgrade_util` to your `pubspec.yaml`:

```yaml
dependencies:
  upgrade_util: ^latest_version
```

```dart
import 'package:upgrade_util/upgrade_util.dart';
```

### Step 2: Get the Apple ID (iOS)

`appleID` is required on iOS. Find it in [App Store Connect](https://appstoreconnect.apple.com) →
My Apps → select the app → **App Information → Apple ID**, or take the digits after `id` in the
App Store link `https://apps.apple.com/app/id<AppleID>`.

## Usage

### Jump to the store detail page

```dart
final bool opened = await UpgradeUtil.launch(
  type: UpgradeOpenType.detail,
  packageName: 'com.tencent.mm', // Android; defaults to the host app's package name
  appleID: '414478124',          // iOS
);
```

### Jump to the write-review page

```dart
final bool opened = await UpgradeUtil.launch(
  type: UpgradeOpenType.review,
  appleID: '414478124',
);
```

> On Android only OPPO (incl. realme, OnePlus), vivo and Honor support review deep links; on
> other markets `review` falls back to the detail page.

### Jump to the review list page (iOS only)

```dart
final bool opened = await UpgradeUtil.launch(
  type: UpgradeOpenType.reviews,
  appleID: '414478124',
);
```

> Throws `UnsupportedError` on Android before any platform call.

The returned `bool` indicates whether the jump was successfully initiated: on iOS the value comes
from the system callback; on Android it only indicates that the target page could be opened, and
does not cover the user's subsequent actions in the market.

## Parameters

### Methods

| Name     | Signature                                                                                | Description                                                              |
|----------|------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|
| `launch` | `({required UpgradeOpenType type, String? packageName, String? appleID}) → Future<bool>` | Jumps to the target app store page and reports whether it was initiated. |

### `launch` parameters

| Name          | Type              | Default  | Description                                                                                              |
|---------------|-------------------|----------|----------------------------------------------------------------------------------------------------------|
| `type`        | `UpgradeOpenType` | required | Target page type.                                                                                        |
| `packageName` | `String?`         | `null`   | Target app package name. **Android only**; defaults to the host app's package name. Ignored on iOS.      |
| `appleID`     | `String?`         | `null`   | The app's Apple ID. **Required on iOS** (an `ArgumentError` is thrown when missing). Ignored on Android. |

### `UpgradeOpenType`

| Value     | Description       | Platform                                                                                                                                        |
|-----------|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| `detail`  | App detail page   | Android, iOS                                                                                                                                    |
| `reviews` | Review list page  | iOS only; throws `UnsupportedError` on Android                                                                                                  |
| `review`  | Write-review page | Android, iOS. On Android only OPPO (incl. realme/OnePlus), vivo and Honor support review deep links; other markets fall back to the detail page |

## Notes

- **Android market detection**: the installed vendor market is matched in priority order —
  Huawei, Honor, Xiaomi, OPPO, vivo, Meizu, Samsung — and the first installed one wins; unlisted
  markets are launched with the generic `market://` protocol.
- **Review deep-link limits (Android)**: supported by OPPO (incl. realme, OnePlus), vivo and
  Honor (market versionCode ≥ 160036301); elsewhere `review` falls back to the detail page.
- **Example app**: see [example/lib/main.dart](example/lib/main.dart) for a complete example.

> If you like my project, please click "Star" in the upper right corner of the project. Your
> support is my biggest encouragement! ^_^
