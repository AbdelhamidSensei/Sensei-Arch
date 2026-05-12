# MetroGo Cairo

Plan your trip on the Cairo Metro in seconds — fully offline, Arabic-first, free.

## Features
- Interactive map of all 3 lines (OSM + schematic diagram)
- Find the nearest metro station via GPS
- Trip planner: A -> B with line transfers, total time, station count, fare estimate
- Search every station in Arabic and English
- Favorites + trip history
- Light & dark themes, Arabic / English UI

## Run locally
1. `flutter pub get`
2. `flutter run`

## Build release APK
```
flutter build apk --release --split-per-abi
```

## Update metro data
All metro data lives in `assets/data/`:
- `stations.json` — station list with coords and lines
- `lines.json` — line metadata (color, name)
- `edges.json` — adjacency + travel times

Edit these files, rebuild, ship. No backend deployment needed.

## Attribution
Map tiles (c) OpenStreetMap contributors, under ODbL.

## License
MIT
