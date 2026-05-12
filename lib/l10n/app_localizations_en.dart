// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MetroGo Cairo';

  @override
  String get tagline => 'Tap, plan, ride.';

  @override
  String get tabMap => 'Map';

  @override
  String get tabPlan => 'Plan';

  @override
  String get tabStations => 'Stations';

  @override
  String get tabFavorites => 'Favorites';

  @override
  String get tabSettings => 'Settings';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get useMyLocation => 'Use my location';

  @override
  String get search => 'Search…';

  @override
  String get nearestStation => 'Nearest station';

  @override
  String boardAt(String station) {
    return 'Board at $station';
  }

  @override
  String alightAt(String station) {
    return 'Get off at $station';
  }

  @override
  String transferAt(String station) {
    return 'Transfer at $station';
  }

  @override
  String estimatedTime(int minutes) {
    return '≈ $minutes min';
  }

  @override
  String fare(int egp) {
    return 'Fare: $egp EGP';
  }

  @override
  String stations(int count) {
    return '$count stations';
  }

  @override
  String get planTrip => 'Plan trip';

  @override
  String get noRoute => 'No route found';

  @override
  String get locationPermissionDenied =>
      'Location permission is needed to find the nearest station.';

  @override
  String get openSettings => 'Open settings';

  @override
  String walkTo(int minutes, String station) {
    return 'Walk $minutes min to $station';
  }

  @override
  String walkFrom(int minutes, String station) {
    return 'Walk $minutes min from $station';
  }

  @override
  String totalSummary(int stations, int minutes, int fare) {
    return '$stations stations · $minutes min · $fare EGP';
  }

  @override
  String get saveTrip => 'Save trip';

  @override
  String get share => 'Share';

  @override
  String get goFromHere => 'Go from here';

  @override
  String get goToHere => 'Go to here';

  @override
  String get favorites => 'Favorites';

  @override
  String get history => 'History';

  @override
  String get noFavorites => 'No favorites yet';

  @override
  String get noHistory => 'No trips planned yet';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get system => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get about => 'About';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get onboarding1Title => 'Find Your Nearest Station';

  @override
  String get onboarding1Desc =>
      'Instantly locate the closest metro station to you with GPS.';

  @override
  String get onboarding2Title => 'Plan Any Trip';

  @override
  String get onboarding2Desc =>
      'Plan your journey across all Cairo Metro lines with transfers.';

  @override
  String get onboarding3Title => 'Works Fully Offline';

  @override
  String get onboarding3Desc =>
      'No internet needed. All metro data is built into the app.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get transfer => 'Transfer';

  @override
  String stops(int count) {
    return '$count stops';
  }

  @override
  String get mapView => 'Map';

  @override
  String get schematicView => 'Diagram';

  @override
  String get allLines => 'All Lines';

  @override
  String get pickOnMap => 'Pick on map';

  @override
  String get stationDetails => 'Station Details';

  @override
  String get linesServed => 'Lines served';

  @override
  String get planFromHere => 'Plan from here';

  @override
  String get planToHere => 'Plan to here';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get checkForUpdates => 'Check for data updates';

  @override
  String get dataUpToDate => 'Metro data is up to date';

  @override
  String get tripSummary => 'Trip Summary';

  @override
  String get direction => 'Direction';

  @override
  String directionToward(String station) {
    return 'Toward $station';
  }

  @override
  String get arrivalTime => 'Est. arrival';

  @override
  String get departNow => 'Depart now';

  @override
  String transfers(int count) {
    return '$count transfer(s)';
  }

  @override
  String get noTransfers => 'Direct — no transfers';

  @override
  String showStops(int count) {
    return 'Show $count stops';
  }

  @override
  String get hideStops => 'Hide stops';

  @override
  String transferWalk(String line, int minutes) {
    return 'Walk to $line platform (~$minutes min)';
  }

  @override
  String get fareNote => 'Ticket price as of 2025';

  @override
  String get totalDuration => 'Total duration';

  @override
  String get rideTime => 'Ride time';

  @override
  String get walkTime => 'Walk time';

  @override
  String get swapStations => 'Swap';
}
