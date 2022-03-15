# Flutter Upgrade Util

[![pub package](https://img.shields.io/pub/v/upgrade_util)](https://pub.dev/packages/upgrade_util)
[![GitHub license](https://img.shields.io/github/license/LiWenHui96/upgrade_util?label=协议&style=flat-square)](https://github.com/LiWenHui96/upgrade_util/blob/master/LICENSE)

Language: [中文](README-ZH.md) | English

At present, the plugin is only used by Android, iOS

### Use of third-party

* Using `dio` to download the apk for Android;

## Preparing for use

### Version constraints

```yaml
  sdk: ">=2.14.0 <3.0.0"
  flutter: ">=2.5.0"
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

### Localized configuration

Add in `MaterialApp`.

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

## Usage

Popups are implemented by using `CupertinoAlertDialog`.

Parameter names and descriptions of `UpgradeDialog`:

| Name                       | Type                        | Description                                                | Default                                       |
|----------------------------|-----------------------------|------------------------------------------------------------|-----------------------------------------------|
| key                        | `Key?`                      | Identifier of the component                                | `ObjectKey(context)`                          |
| iOSAppId                   | `String`                    | App Store number for iOS                                   | Required                                      |
| androidUpgradeInfo         | `AndroidUpgradeInfo`        | The upgrade info for Android                               | Required                                      |
| title                      | `String?`                   | Title                                                      | `UpgradeLocalizations.of(context).title`      |
| titleTextStyle             | `TextStyle?`                | TitleTextStyle                                             | `null`                                        |
| titleStrutStyle            | `StrutStyle?`               | TitleStrutStyle                                            | `null`                                        |
| content                    | `String?`                   | What's new in the version                                  | `UpgradeLocalizations.of(context).content`    |
| contentTextStyle           | `TextStyle?`                | ContentTextStyle                                           | `null`                                        |
| contentStrutStyle          | `StrutStyle?`               | ContentStrutStyle                                          | `null`                                        |
| contentTextAlign           | `TextAlign`                 | The alignment of `content`                                 | `TextAlign.start`                             |
| scrollController           | `ScrollController?`         | `CupertinoAlertDialog.scrollController`                    | `null`                                        |
| actionScrollController     | `ScrollController?`         | `CupertinoAlertDialog.actionScrollController`              | `null`                                        |
| force                      | `bool`                      | Is it a mandatory update                                   | `false`                                       |
| updateKey                  | `Key?`                      | The component identifier for the OK (upgrade) button       | `null`                                        |
| updateText                 | `String?`                   | Text of OK (Upgrade) button                                | `UpgradeLocalizations.of(context).updateText` |
| updateTextStyle            | `TextStyle?`                | Text style for OK (Upgrade) button                         | `null`                                        |
| isUpgradeDefaultAction     | `bool`                      | Determine if the OK (Upgrade) button is the default option | `false`                                       |
| isUpgradeDestructiveAction | `bool`                      | Determine if the OK (Upgrade) button is a destroy action   | `false`                                       |
| cancelKey                  | `Key?`                      | The component identifier for the cancel button             | `null`                                        |
| cancelText                 | `String?`                   | Text of Cancel button                                      | `UpgradeLocalizations.of(context).cancelText` |
| cancelTextStyle            | `TextStyle?`                | Text style for Cancel button                               | `null`                                        |
| isCancelDefaultAction      | `bool`                      | Determine if the Cancel button is the default option       | `false`                                       |
| isCancelDestructiveAction  | `bool`                      | Determine if the Cancel button is a destroy action         | `true`                                        |
| updateCallback             | `VoidCallback?`             | Click event listener for OK (upgrade) button               | `null`                                        |
| cancelCallback             | `VoidCallback?`             | Click event listener for Cancel button                     | `null`                                        |
| downloadProgressCallback   | `DownloadProgressCallback?` | Progress monitoring of download events                     | `null`                                        |
| downloadStatusCallback     | `DownloadStatusCallback?`   | Status listener of download events                         | `null`                                        |

### iOS

* `iOSAppId` is the application number of the App Store, please make sure the app is published and available;
* `androidUpgradeInfo`, are invalid on iOS platform.

### Android

Field description of `AndroidUpgradeInfo`

| Name           | Type             | Description                                                              | Default               |
|----------------|------------------|--------------------------------------------------------------------------|-----------------------|
| packageName    | `String`         | The package name for Android                                             | Required              |
| androidMarket  | `AndroidMarket?` | The App Market Configuration for Android                                 | `AndroidMarket()`     |
| otherMarkets   | `List<String>?`  | The package name of the app market that is not preset in `AndroidMarket` | `null`                |
| downloadUrl    | `String?`        | The download link for apk                                                | ` `                   |
| saveApkName    | `String?`        | The save name of the apk file                                            | `temp`                |
| savePrefixName | `String?`        | The folder where the apk file is saved                                   | `libCacheApkDownload` |

* `androidMarket` application market detailed configuration can be
  viewed [AndroidMarket](lib/src/android/android_market.dart);
* `androidMarket` and `downloadUrl` need to be configured; if both are configured, `androidMarket` is the priority;
* `saveApkName` does not need to carry a suffix, the default setting is `.apk`;
* `savePrefixName` does not need to concatenate `/`, the default configuration is `/${savePrefixName}/`.

## Method

### iOS

To jump to the App Store or the application market, use the `jumpToStore` method

* The required item is `jumpMode`, so far, there are three modes;
    1. `JumpMode.detailPage`, jump to the application details page (ie the product introduction page);
    2. `JumpMode.reviewsPage`, jump to the app review page (IOS unique mode);
    3. `JumpMode.writeReview`, jump to the app review page and comment (IOS unique mode).
* `iOSAppId` is required for iOS, which is the application number of the App Store；
* `androidPackageName` is required for Android, this is the app package name；
* `androidMarketPackageName` is the package name of the application market that Android jumps to, not required.

### Android unique method

1. `getDownloadPath`, get the download address of the apk;
2. `installApk`, install the apk, and jump to the installation guide page;
3. `getAvailableMarket`, get the currently available application market.

