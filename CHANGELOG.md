## 4.0.0

* Add `UpgradeUtil.launch` with `UpgradeOpenType`: jump to the app store detail page, the review list page, or the write-review page, and return whether the jump was successfully initiated.
* Android: automatically detect the installed vendor app market (Huawei, Honor, Xiaomi, OPPO, vivo, Meizu, Samsung) and launch it with the brand-specific scheme; unlisted markets use the generic `market://` protocol.
* Android: support write-review deep links for OPPO (incl. realme, OnePlus), vivo and Honor (market versionCode ≥ 160036301); other markets fall back to the detail page.
* Android: defer installed-market detection until the user triggers a jump, to comply with privacy requirements on reading the installed-app list.
* Android: upgrade the build to AGP 8.11.1, Kotlin 2.2.20, Java 17 and compileSdk 36.
* iOS: open the App Store detail page, the review list page and the write-review page via `itms-apps://` links.
* iOS: support Swift Package Manager (iOS 15+) alongside CocoaPods, and bundle the privacy manifest.

### BREAKING CHANGES

* Flutter minimum version `3.41.0`, Dart minimum version `3.11.0`.
* Android `minSdk` raised from 21 to 24; iOS deployment target raised from 12.0 to 15.0.
* Remove `UpgradeUtil.openStore`, `UpgradeOption`, `IOSUpgradeOption`, `AndroidUpgradeOption` and `AndroidBrand`. Use `UpgradeUtil.launch` with `UpgradeOpenType` instead. For details on how to use it, see [README.md](README.md).
* The review list page (`UpgradeOpenType.reviews`) is only supported on iOS; calling it on Android throws `UnsupportedError`.

## 3.1.0

* Delete The label of Brand.

## 3.0.2

* Add The label of Brand.

## 3.0.1

* Format Code.

## 3.0.0

* Flutter minimum version `3.24.0`.
* Use `UpgradeUtil.openStore` to App Store.
* The download function of pop-up window and APK is no longer provided.

## 2.3.7

* Support AGP 8 and Fix Compile Issue.

## 2.3.6+1

* Flutter minimum version `3.13.0`

## 2.3.6

* Flutter minimum version `3.12.0`

## 2.3.5+1

* Fix `WillPopScope`.

## 2.3.5

* Add HiHonor Market for Android.

### BREAKING CHANGES

* Flutter minimum version `3.10.0`

## 2.3.4+1

* Optimize.

## 2.3.4

* Add `titleWidget`, `contentWidget`.

## 2.3.3

* In forced update mode, the popup no longer closes.

## 2.3.2

* Fixed the issue that the click event of the upgrade button of the iOS pop-up window was invalid.

## 2.3.1

* The version limit of Android application permission is O, O_MR1, P.

## 2.3.0

Introduces new `downloadUri` API; `downloadUrl` are now deprecated. These new APIs:

* replace the `String` URL argument with a `Uri`, to prevent common issues with providing invalid URL strings.
* Add `downloadInterceptors`, `deleteOnError`, `lengthHeader`, `data`, `options` to dio.
* Reorganizes and clarifies README.
* Add new function basis [#2](https://github.com/LiWenHui96/upgrade_util/issues/2).

## 2.2.4

* The `packageName` field is no longer provided because the package name of the project is used uniformly.

## 2.2.3

* Modify the judgment method of the platform.

## 2.2.2

* Update description.
* Minor fixes for new analysis options.

## 2.2.1+2

* Update README.md.

## 2.2.1+1

* Update README.md.

## 2.2.1

* We've ushered in major changes, not just method changes, but more performance improvements.

### Breaking changes

* Use `showUpgradeDialog<T>()` instead of `UpgradeDialog.show<T>()`.
* Organize trivial parameters. Use `UpgradeConfig`, `IosUpgradeConfig`, `AndroidUpgradeConfig`.
* The default `content` is no longer used.
* For details on how to use it, see [README.md](README.md).

## 2.2.0-alpha.4

* Add `updateButtonStyle`、`isExistsFile`、`indicatorHeight`、`indicatorTextSize` to the config of Android.
* Change `UiUpgradeConfig` to `UpgradeConfig`.

## 2.2.0-alpha.3

* Add logs.
* Optimize the download process.

## 2.2.0-alpha.2

* Use stricter judgment criteria.
* The default `content` is no longer used.

## 2.2.0-alpha.1

* We've ushered in major changes, not just method changes, but more performance improvements.

### Breaking changes

* Use `showUpgradeDialog<T>()` instead of `UpgradeDialog.show<T>()`.
* Organize trivial parameters. Use `UiUpgradeConfig`, `IosUpgradeConfig`, `AndroidUpgradeConfig`.
* For details on how to use it, see [README.md](README.md).

## 2.1.4

* Fix where Android's cancellation button was incorrectly displayed when downloading in Stronger Mode.

## 2.1.3

* Fix [#1](https://github.com/LiWenHui96/upgrade_util/issues/1)

## 2.1.2

* Add `AndroidView` click event.
* Upgrade README.md

## 2.1.1

* Raise score.

## 2.1.0

* Daily upgrade.

## 2.0.0

* Welcome to a brand new version.
* `AndroidUtil` and `IOSUpgradeUtil` have given up.
* Use `UpgradeUtil` to instead of `AndroidUtil` and `IOSUpgradeUtil`.
* Use `AndroidUpgradeInfo` to fill in the information of Android upgrade.
* No longer use the `url_launcher` plugin.
* For details on how to use it, see [README.md](README.md)

## 1.0.3

* Update README.md.

## 1.0.2

* Update README.md.
* Update pubspec.yaml.

## 1.0.1

* Update pubspec.yaml.

## 1.0.0

* Update README.md.

## 0.1.0

* Release the first edition.

## 0.0.9+2

* Add `AndroidView` click event.
* Update README.md.

## 0.0.9+1

* Update README.md.

## 0.0.9

* Support old version.
