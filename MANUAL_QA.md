# MetroGo Cairo — Manual QA Checklist

## Setup
- [ ] Install `build/app/outputs/flutter-apk/app-release.apk` on a real device

## RTL / Localization
- [ ] Set device language to Arabic -> UI is RTL, all strings in Arabic
- [ ] Switch device language to English -> UI flips to LTR
- [ ] In-app language toggle (Settings) overrides system language

## Location
- [ ] Grant location permission -> Map tab shows "you are here" blue pin
- [ ] Tap locate-me FAB -> map centers on user position
- [ ] Deny location -> Plan tab still works via manual station picking

## Trip Planning
- [ ] Pick From = Sadat, To = El Mounib -> trip shows board=Sadat, alight=El Mounib, line M2, no transfers
- [ ] Pick From = Helwan, To = Cairo University -> plan shows transfer at Sadat, 2 segments
- [ ] Fare displayed matches station count bracket (8/10/15/20 EGP)
- [ ] Trip auto-saved to History

## Stations
- [ ] Stations list loads all stations grouped/filterable by line
- [ ] Search works in both Arabic and English
- [ ] Tapping a station opens details with line chips and plan buttons

## Map
- [ ] OSM map loads with 3 colored polylines and station markers
- [ ] Tapping station marker opens bottom sheet with "Go from here" / "Go to here"
- [ ] Schematic diagram tab shows simplified line diagram

## Favorites
- [ ] Add a station to favorites -> appears in Favorites tab
- [ ] Restart app -> favorite still persists
- [ ] Swipe to delete a favorite

## History
- [ ] Plan a trip -> appears in History tab
- [ ] Tap history item -> navigates to plan page with stations pre-filled
- [ ] History limited to 10 most recent items

## Theme
- [ ] Toggle dark theme in Settings -> all surfaces readable
- [ ] Line chips (red/yellow/green) remain visible in dark mode
- [ ] Map markers remain visible in dark mode

## Release Build Specific
- [ ] ProGuard does not strip Hive adapters (favorites persist across restart)
- [ ] Geolocator works in release build (no MissingPluginException)
- [ ] App launches without crash on Android 6.0+ device
