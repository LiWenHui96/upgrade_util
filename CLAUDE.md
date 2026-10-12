# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`upgrade_util` is a Flutter plugin (published to pub.dev) for in-app updates: redirecting users to app stores, previewing reviews, and writing reviews. Supports Android and iOS.

**Current state:** the Dart API surface was re-scaffolded from a newer Flutter plugin template (commits like "基于3.44.9升级" = upgraded based on Flutter 3.44.9), and the scaffold's `getPlatformVersion()` method has since been removed from Dart, Android and iOS. `lib/` now exposes `UpgradeUtil.launch({required UpgradeOpenType type, ...})`, which routes to the native `launch` method over the `upgrade_util` MethodChannel. `README.md`/`CHANGELOG.md` still describe the fuller historical API (`UpgradeUtil.openStore`, `UpgradeOption`, `IOSUpgradeOption`, `AndroidUpgradeOption`, `AndroidBrand`). When asked to implement store-opening features, follow the README's documented API as the spec.

## Commands

```bash
flutter pub get                          # install dependencies
flutter analyze                          # lint (strict ruleset, see analysis_options.yaml)
flutter test                             # all Dart unit tests
flutter test test/upgrade_util_test.dart # single test file

cd example && flutter run                # run example app on a connected device/emulator
```

Android plugin unit tests (JUnit 5 + Mockito, in `android/src/test/kotlin/`) run through the example's Gradle wrapper:

```bash
cd example/android && ./gradlew :upgrade_util:testDebugUnitTest
```

## Release Process

Pushing a version tag (`X.Y.Z`) triggers `.github/workflows/release.yml`, which extracts the matching section from `CHANGELOG.md` and creates a GitHub Release. When releasing: bump `version` in `pubspec.yaml`, add a `## X.Y.Z` section to `CHANGELOG.md`, then tag.

## Architecture

Standard Flutter plugin platform-interface pattern, organized as `part` files:

- `lib/upgrade_util.dart` — public entrypoint, single `export` of the interface library.
- `lib/interface/upgrade_util.dart` — the `library` directive; declares `part` files and the public `UpgradeUtil` facade class that delegates to `UpgradeUtilPlatform.instance`.
- `lib/interface/upgrade_util_platform_interface.dart` — `UpgradeUtilPlatform` (extends `PlatformInterface` with token verification); new platform implementations extend this.
- `lib/interface/upgrade_util_method_channel.dart` — `MethodChannelUpgradeUtil`, the default implementation, using channel name `upgrade_util`.

Native sides:

- **Android**: Kotlin, `android/src/main/kotlin/org/leoli/plugin/upgrade_util/UpgradeUtilPlugin.kt`. Build config in `android/build.gradle.kts`: AGP 8.11.1, Kotlin 2.2.20, Java 17 toolchain, compileSdk 36, minSdk 24.
- **iOS**: Swift, `ios/upgrade_util/Sources/upgrade_util/UpgradeUtilPlugin.swift`. Distributed both as a Swift Package (`ios/upgrade_util/Package.swift`, iOS 15+) and via CocoaPods (`ios/upgrade_util.podspec`, iOS 13+) — keep both manifests in sync when adding sources/resources. The privacy manifest (`PrivacyInfo.xcprivacy`) is bundled through the podspec `resource_bundles`; the SPM `Package.swift` has the corresponding `.process` line commented out — uncomment it if the manifest gains required-reason APIs.

Adding a new plugin method requires touching five places: `UpgradeUtil` facade, `UpgradeUtilPlatform` (throwing `UnimplementedError` default), `MethodChannelUpgradeUtil`, and both native `handle`/`onMethodCall` switch statements.

## Code Style

`analysis_options.yaml` is unusually strict (mirrors flutter/flutter repo conventions): `strict-casts`, `strict-inference`, ~90 lint rules including `always_specify_types`, `prefer_single_quotes`, `require_trailing_commas`, `unawaited_futures`. Formatter page width is 120. Run `flutter analyze` before considering any Dart change complete.