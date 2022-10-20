# Flutter Upgrade Util

[![pub package](https://img.shields.io/pub/v/upgrade_util)](https://pub.dev/packages/upgrade_util)
[![GitHub license](https://img.shields.io/github/license/LiWenHui96/upgrade_util?label=协议&style=flat-square)](https://github.com/LiWenHui96/upgrade_util/blob/master/LICENSE)

Language: [中文](README-ZH.md) | English

At present, the plugin is only used by Android, iOS.

### Use of third-party

* Using `dio` to download the apk for Android, which is built-in in the plugin and does not need to be referenced;

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

### showUpgradeDialog

Popups are implemented by using `showUpgradeDialog`.

| Name                 | Type                    | Description                        | Default                                                                                                                                                                          |
|----------------------|-------------------------|------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| context              | BuildContext            | Context                            | Required                                                                                                                                                                         |
| key                  | `Key?`                  | Identifier of the component        | `null`                                                                                                                                                                           |
| upgradeConfig        | `UpgradeConfig?`        | Dialog style                       | `UpgradeConfig(title: UpgradeLocalizations.of(context).title, updateText: UpgradeLocalizations.of(context).updateText, cancelText: UpgradeLocalizations.of(context).cancelText)` |
| iOSUpgradeConfig     | `IosUpgradeConfig?`     | iOS upgrade config                 | `IosUpgradeConfig()`                                                                                                                                                             |
| androidUpgradeConfig | `AndroidUpgradeConfig?` | Android upgrade config             | `AndroidUpgradeConfig(androidMarket: AndroidMarket(), downloadCancelText: UpgradeLocalizations.of(context).androidCancel)`                                                       |
| isDebugLog           | `bool`                  | Whether to print logs              | `false`                                                                                                                                                                          |
| barrierLabel         | `String?`               | barrierLabel                       | `null`                                                                                                                                                                           |
| arguments            | `Object?`               | The arguments passed to this route | `null`                                                                                                                                                                           |

### UpgradeConfig

Popups are implemented by using `UpgradeConfig`.

| Name              | Type          | Description                                                          | Default                                       |
|-------------------|---------------|----------------------------------------------------------------------|-----------------------------------------------|
| force             | `bool`        | Whether to force the update                                          | `false`                                       |
| titleWidget       | `Widget?`     | The layout of the title. When it is empty, use [Text] instead.       | `null`                                        |
| title             | `String?`     | A title of the version.                                              | `UpgradeLocalizations.of(context).title`      |
| titleTextStyle    | `TextStyle?`  | The text style of `title`                                            | `null`                                        |
| titleStrutStyle   | `StrutStyle?` | The strut style of `title`                                           | `null`                                        |
| contentWidget     | `Widget?`     | The layout of the description. When it is empty, use [Text] instead. | `null`                                        |
| content           | `String?`     | A description of the version                                         | `null`                                        |
| contentTextStyle  | `TextStyle?`  | The text style of `content`                                          | `null`                                        |
| contentStrutStyle | `StrutStyle?` | The strut style of `content`                                         | `null`                                        |
| updateText        | `String?`     | Text message of the update button                                    | `UpgradeLocalizations.of(context).updateText` |
| updateTextStyle   | `TextStyle?`  | The text style of `updateText`                                       | `null`                                        |
| cancelText        | `String?`     | Text message of cancel button                                        | `UpgradeLocalizations.of(context).cancelText` |
| cancelTextStyle   | `TextStyle?`  | The text style of `cancelText`                                       | `null`                                        |

### IosUpgradeConfig

Popups are implemented by using `IosUpgradeConfig`.

| Name                       | Type                | Description                                                                                  | Default |
|----------------------------|---------------------|----------------------------------------------------------------------------------------------|---------|
| appleId                    | `String?`           | Apple ID                                                                                     | `null`  |
| scrollController           | `ScrollController?` | A scroll controller that can be used to control the scrolling of the `content` in the dialog | `null`  |
| actionScrollController     | `ScrollController?` | A scroll controller that can be used to control the scrolling of the `actions` in the dialog | `null`  |
| isUpgradeDefaultAction     | `bool`              | Set to true if button is the default choice in the dialog                                    | `false` |
| isUpgradeDestructiveAction | `bool`              | Whether this action destroys an object                                                       | `false` |
| isCancelDefaultAction      | `bool`              | Set to true if button is the default choice in the dialog                                    | `false` |
| isCancelDestructiveAction  | `bool`              | Whether this action destroys an object                                                       | `true`  |

### AndroidUpgradeConfig

Popups are implemented by using `AndroidUpgradeConfig`.

| Name                       | Type                        | Description                                                              | Default                                          |
|----------------------------|-----------------------------|--------------------------------------------------------------------------|--------------------------------------------------|
| androidMarket              | `AndroidMarket?`            | The settings of app market for Android                                   | `AndroidMarket()`                                |
| otherMarkets               | `List<String>`              | The package name of the app market that is not preset in `AndroidMarket` | `<String>[]`                                     |
| dialogBorderRadius         | `BorderRadius?`             | The dialog's borderRadius.                                               | `BorderRadius.circular(10)`                      |
| topImageProvider           | `ImageProvider?`            | Picture at the top of the dialog                                         | `null`                                           |
| topImageHeight             | `double?`                   | Height of the image                                                      | `null`                                           |
| updateButtonStyle          | `ButtonStyle?`              | The style of the upgrade button                                          | `null`                                           |
| downloadCancelText         | `String?`                   | Cancel text when downloading                                             | `UpgradeLocalizations.of(context).androidCancel` |
| downloadUri                | `Uri?`                      | A link of download for Apk                                               | `null`                                           |
| saveName                   | `String?`                   | The name of the file after the apk download is completed                 | `temp.apk`                                       |
| downloadInterceptors       | `List<Interceptor>`         | Interceptors added to [Dio]                                              | `<Interceptor>[]`                                |
| deleteOnError              | `bool`                      | Whether delete the file when error occurs                                | `true`                                           |
| lengthHeader               | `String`                    | The real size of original file (not compressed)                          | `Headers.contentLengthHeader`                    |
| data                       | `dynamic`                   | The request data                                                         | `null`                                           |
| options                    | `Options?`                  | Every request can pass a [Options] object                                | `null`                                           |
| isExistsFile               | `bool`                      | Verify the existence of the file named `saveName`                        | `false`                                          |
| indicatorHeight            | `double?`                   | The height of the indicator                                              | `10px`                                           |
| indicatorBackgroundColor   | `Color?`                    | It is `LinearProgressIndicator.backgroundColor`                          | `null`                                           |
| indicatorColor             | `Color?`                    | It is `LinearProgressIndicator.color`                                    | `null`                                           |
| indicatorValueColor        | `Color?`                    | It is `LinearProgressIndicator.valueColor`                               | `null`                                           |
| indicatorTextSize          | `double?`                   | The text size of the indicator                                           | `8px`                                            |
| indicatorTextColor         | `Color?`                    | The text color of the indicator                                          | `null`                                           |
| onDownloadProgressCallback | `DownloadProgressCallback?` | Realize the listening event of download progress                         | `null`                                           |
| onDownloadStatusCallback   | `DownloadStatusCallback?`   | Realize the listening event of download status                           | `null`                                           |

* `androidMarket` application market detailed configuration can be
  viewed [AndroidMarket](lib/src/android_market.dart);
* `androidMarket` and `downloadUrl` need to be configured; if both are configured, `androidMarket` is the priority;

## Method

To jump to the App Store or the application market, use the `jumpToStore` method

* The required item is `jumpMode`, so far, there are three modes;
    1. `JumpMode.detailPage`, jump to the application details page (ie the product introduction page);
    2. `JumpMode.reviewsPage`, jump to the app review page;
    3. `JumpMode.writeReview`, jump to the app review page and comment.
* `appleId` is required for iOS, which is the application number of the App Store；
* `marketPackageName` is the package name of the application market that Android jumps to, not required.
* The `packageName` field is no longer provided because the package name of the project is used uniformly.

### Android unique method

1. `getDownloadPath`, get the save path of the software download；
2. `installApk`, install the apk, and jump to the installation guide page；
3. `getMarkets` get a list of software information for the application market contained in the mobile phone.

> If you like my project, please in the upper right corner of the project "Star". Your support is my biggest encouragement! ^_^
