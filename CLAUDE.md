# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`upgrade_util` is a Flutter plugin (published to pub.dev) for in-app updates: redirecting users to app stores, previewing reviews, and writing reviews. Supports Android and iOS.

**Current API:** `UpgradeUtil.launch({required UpgradeOpenType type, String? packageName, String? appleID})` returns `Future<bool>` (whether the jump was successfully initiated). `UpgradeOpenType` (`lib/src/enum.dart`) has three targets: `detail` (store detail page), `reviews` (review list — iOS only), `review` (write-review page). On Android the review deep link only exists for some markets (OPPO, vivo, Honor) and falls back to the detail page elsewhere.

**`CHANGELOG.md` is stale**: it still describes the removed historical API (`UpgradeUtil.openStore`, `UpgradeOption`, `AndroidBrand`, …). The READMEs (`README.md` / `README-ZH.md`) document the current `launch` API — keep both in sync with each other and with `lib/` when the API changes.

## Commands

```bash
flutter pub get                          # install dependencies
flutter analyze                          # lint (strict ruleset, see analysis_options.yaml)
flutter test                             # all Dart unit tests
flutter test test/upgrade_util_test.dart # single test file

cd example && flutter run                # run example app on a connected device/emulator

# Native unit tests
cd example/android && ./gradlew testDebugUnitTest   # Android/Kotlin tests (JUnit, Mockito)
# iOS: example/ios/RunnerTests (XCTest) — run from Xcode's test navigator or xcodebuild
```

## Release Process

Pushing a version tag (`X.Y.Z`) triggers `.github/workflows/release.yml`, which extracts the matching `## X.Y.Z` section from `CHANGELOG.md` and creates a GitHub Release. When releasing: bump `version` in `pubspec.yaml`, add a `## X.Y.Z` section to `CHANGELOG.md`, then tag.

## Architecture

Standard Flutter plugin platform-interface pattern, organized as `part` files:

- `lib/upgrade_util.dart` — public entrypoint, single `export` of the interface library.
- `lib/interface/upgrade_util.dart` — the `library` directive; declares `part` files and the public `UpgradeUtil` facade class that delegates to `UpgradeUtilPlatform.instance`.
- `lib/interface/upgrade_util_platform_interface.dart` — `UpgradeUtilPlatform` (extends `PlatformInterface` with token verification); new platform implementations extend this.
- `lib/interface/upgrade_util_method_channel.dart` — `MethodChannelUpgradeUtil`, the default implementation, using channel name `upgrade_util`.

**Method routing is asymmetric per platform** — `MethodChannelUpgradeUtil.launch` branches on `defaultTargetPlatform`:

- **Android**: maps the type to one of two native methods, `launchDetail` or `launchReview` (`reviews` throws `UnsupportedError` before any channel call).
- **iOS**: builds the `itms-apps://` URL in Dart (detail / reviews / write-review) and calls the single native method `launch` with that URL. The Apple ID is validated in Dart; the native side only opens the URL.

Native sides:

- **Android** (Kotlin, `android/src/main/kotlin/org/leoli/plugin/upgrade_util/`):
  - `UpgradeUtilPlugin.kt` — method dispatch, Activity lifecycle, Intent launching.
  - `AppMarkets.kt` — registry of vendor app markets (Huawei, Honor, Xiaomi, OPPO ×2, vivo, Meizu, Samsung): package names, per-market detail-page and review deep-link templates, and install detection. `all` is ordered — the first installed market wins. Constraints baked in here:
    - The detected installed market is cached in a `lazy` property on purpose: installed-app lists are personal data, so detection is deferred until the user triggers a jump (privacy-compliance requirement for store review).
    - OPPO markets silently fail on implicit intents — they must be launched via `startActivityForResult` (see `requireActivityResult`).
    - Honor's `market://comment` review link requires a minimum market versionCode (`HONOR_COMMENT_MIN_VERSION`).
    - Adding a market means adding its package name to **both** `AppMarkets` and the `<queries>` block in `android/src/main/AndroidManifest.xml` (Android 11+ package visibility), or install detection will never see it.
  - Build config in `android/build.gradle.kts`: AGP 8.11.1, Kotlin 2.2.20, Java 17 toolchain, compileSdk 36, minSdk 24.
- **iOS** (Swift, `ios/upgrade_util/Sources/upgrade_util/UpgradeUtilPlugin.swift`): thin — one `launch` method that opens the URL it receives and returns the system callback's success flag. Distributed both as a Swift Package (`ios/upgrade_util/Package.swift`, iOS 15+) and via CocoaPods (`ios/upgrade_util.podspec`, iOS 13+) — keep both manifests in sync when adding sources/resources. The privacy manifest (`PrivacyInfo.xcprivacy`) is bundled through the podspec `resource_bundles`; the SPM `Package.swift` has the corresponding `.process` line commented out — uncomment it if the manifest gains required-reason APIs.

Adding a new plugin method requires touching five places: `UpgradeUtil` facade, `UpgradeUtilPlatform` (throwing `UnimplementedError` default), `MethodChannelUpgradeUtil`, and both native `handle`/`onMethodCall` switch statements.

## Code Style

`analysis_options.yaml` is unusually strict (mirrors flutter/flutter repo conventions): `strict-casts`, `strict-inference`, ~90 lint rules including `always_specify_types`, `prefer_single_quotes`, `require_trailing_commas`, `unawaited_futures`. Formatter page width is 120. Run `flutter analyze` before considering any Dart change complete.

Source files carry `@Describe` / `@Author` / `@Date` header comment blocks — preserve them when editing or reformatting comments.