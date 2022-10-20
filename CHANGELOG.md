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
