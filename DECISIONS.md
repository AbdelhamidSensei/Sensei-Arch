# DECISIONS.md — PhotoRevive AI

All defaults and decisions made during the build are recorded here.

## Phase 0
- **Existing project**: Reusing existing Flutter project scaffold (was "sensei"). Renaming to `photo_revive_ai`.
- **Flutter version**: 3.38.7 (Dart 3.10.7) — newer than spec's 3.24+. SDK constraint updated to `>=3.10.7 <4.0.0`.
- **No `flutter create`**: Project already initialized. Restructuring in place.

## Phase 1
- **riverpod_generator & hive_generator removed**: Analyzer version conflict between the two packages. Providers and Hive adapters written manually instead of using code generation.
- **riverpod_annotation removed**: Not needed without riverpod_generator.
- **custom_lint & riverpod_lint removed**: Depend on riverpod_generator ecosystem.
- **network_image_mock removed**: Not available / not needed for current tests.
- **before_after package removed**: Custom BeforeAfterWidget built instead (simpler, no dependency).
- **image_cropper removed**: Old Android Gradle Plugin (3.6.4) caused SSL resolution failures. Crop functionality can be added later with a newer version.
- **image_picker_android pinned to 0.8.13+15**: Version 0.8.13+17 requires Kotlin 2.3.20 which was not cached locally and couldn't be downloaded due to corporate SSL proxy.
- **flutter_lints 6.0.0** used instead of spec's 4.0.0 (newer Flutter needs newer lints).
- **Dependency versions**: Let pub resolve latest compatible. 200 packages resolved successfully.
- **Font bundling**: Skipped bundling Plus Jakarta Sans TTF files in assets/fonts/. Using `google_fonts` package which fetches at runtime. Recorded per spec's gotcha #1.

## Phase 2
- **Mock enhancer**: When REPLICATE_API_TOKEN is empty, MockEnhancementRepository is used. Returns input image as output after 3s delay.
- **API key exposure note**: For production, deploy a proxy server to hold the token. This is a v1.1 todo.

## Phase 3-4
- **Theme**: Implemented exactly per spec with Material 3, brand gradient, Plus Jakarta Sans via google_fonts.
- **ThemeMode**: Persisted in Hive 'settings' box, respects system/light/dark toggle.

## Phase 8
- **UCropActivity**: Removed from AndroidManifest after removing image_cropper dependency.

## Phase 11
- **ProGuard rules**: Added comprehensive rules for Flutter, Kotlin, Hive, permission_handler, and billing.

## Phase 12
- **Compile SDK**: Set to 36 (bumped from spec's 34) because `flutter_plugin_android_lifecycle` and `gal` require SDK 36+.
- **NDK**: Set to 28.2.13676358 explicitly (NDK 27 was corrupted on this system).
- **Release signing**: Configured with key.properties file pattern.

## Phase 13
- **Keystore**: Generated with dev credentials. MUST be replaced before Play Store publication.
- **Keystore password**: `photorevive123` — development only.

## Phase 14
- **SSL fix**: Corporate proxy (IDH ROOT-CA) was intercepting SSL. Had to import the corporate CA cert into both JDK cacerts (E:\jdk-17.0.10 and Android Studio JBR).
- **Build output**: Universal APK 52MB, split APKs: arm64 19.3MB, armeabi-v7a 17MB, x86_64 20.6MB.
