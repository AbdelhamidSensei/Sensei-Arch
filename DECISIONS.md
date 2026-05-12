# MetroGo Cairo — Design Decisions

## Flutter Version
- Using Flutter 3.38.7 / Dart 3.10.7 (newer than spec's 3.24+). SDK constraint set to `>=3.10.0 <4.0.0`.

## Package Changes
- Removed `freezed`, `json_serializable`, `freezed_annotation`, `json_annotation`, `build_runner`, `riverpod_annotation`, `riverpod_generator`, `custom_lint`, `riverpod_lint` due to `_macros` SDK incompatibility with Dart 3.10.x. These packages conflict with `hive_generator` on the `analyzer` dependency.
- Removed `hive_generator` — Hive TypeAdapters are written manually instead of code-generated.
- Models (Station, MetroLine, TripPlan, TripSegment) use plain Dart classes with manual `fromJson`/`toJson` instead of freezed.
- RadioListTile deprecated in Flutter 3.38+ — replaced with ListTile-based selection in settings dialogs.

## Station Data
- Station data is best-effort as of build date; users should treat fares and a few station names as approximate. Update before publishing.
- Nasser station is listed as serving all 3 lines (L1, L2, L3) per most Cairo Metro maps.
- Line 3 includes stations up to Rod El-Farag Corridor (29 stations). Some recently opened extension stations may be missing.
- Skipped/uncertain Line 3 stations: Tawfikeya, Wadi El-Nil, Gamal Abdel-Nasser (these may be under construction or renamed). Add them to `stations.json` and `edges.json` manually when confirmed.

## Fare Table
- Fare values (8/10/15/20 EGP) are placeholders based on 2024 rates. Verify with the National Authority for Tunnels (NAT) before release.

## Font Fallback
- Arabic text uses Tajawal (Google Fonts). English text uses Plus Jakarta Sans.
- Falls back to system font if Google Fonts fails to load.

## OSM Tile Attribution
- Map tiles from OpenStreetMap (`tile.openstreetmap.org`). For production (>100k tile fetches/day), switch to MapTiler or Stadia Maps.
- `userAgentPackageName` set to `com.abdelhamidsensei.metrogo`.

## Android Build
- `compileSdk` bumped to 36 (required by geolocator_android, shared_preferences_android, url_launcher_android).
- Java 21 toolchain used (from Android Studio JBR).
- ProGuard/R8 enabled for release builds.

## Architecture
- Clean Architecture with feature-based folder structure.
- State management: manual Riverpod providers (no code generation).
- Routing: GoRouter with ShellRoute for bottom navigation persistence.
