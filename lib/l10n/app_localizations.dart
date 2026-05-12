import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MetroGo Cairo'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Tap, plan, ride.'**
  String get tagline;

  /// No description provided for @tabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get tabMap;

  /// No description provided for @tabPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get tabPlan;

  /// No description provided for @tabStations.
  ///
  /// In en, this message translates to:
  /// **'Stations'**
  String get tabStations;

  /// No description provided for @tabFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get tabFavorites;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search…'**
  String get search;

  /// No description provided for @nearestStation.
  ///
  /// In en, this message translates to:
  /// **'Nearest station'**
  String get nearestStation;

  /// No description provided for @boardAt.
  ///
  /// In en, this message translates to:
  /// **'Board at {station}'**
  String boardAt(String station);

  /// No description provided for @alightAt.
  ///
  /// In en, this message translates to:
  /// **'Get off at {station}'**
  String alightAt(String station);

  /// No description provided for @transferAt.
  ///
  /// In en, this message translates to:
  /// **'Transfer at {station}'**
  String transferAt(String station);

  /// No description provided for @estimatedTime.
  ///
  /// In en, this message translates to:
  /// **'≈ {minutes} min'**
  String estimatedTime(int minutes);

  /// No description provided for @fare.
  ///
  /// In en, this message translates to:
  /// **'Fare: {egp} EGP'**
  String fare(int egp);

  /// No description provided for @stations.
  ///
  /// In en, this message translates to:
  /// **'{count} stations'**
  String stations(int count);

  /// No description provided for @planTrip.
  ///
  /// In en, this message translates to:
  /// **'Plan trip'**
  String get planTrip;

  /// No description provided for @noRoute.
  ///
  /// In en, this message translates to:
  /// **'No route found'**
  String get noRoute;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is needed to find the nearest station.'**
  String get locationPermissionDenied;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @walkTo.
  ///
  /// In en, this message translates to:
  /// **'Walk {minutes} min to {station}'**
  String walkTo(int minutes, String station);

  /// No description provided for @walkFrom.
  ///
  /// In en, this message translates to:
  /// **'Walk {minutes} min from {station}'**
  String walkFrom(int minutes, String station);

  /// No description provided for @totalSummary.
  ///
  /// In en, this message translates to:
  /// **'{stations} stations · {minutes} min · {fare} EGP'**
  String totalSummary(int stations, int minutes, int fare);

  /// No description provided for @saveTrip.
  ///
  /// In en, this message translates to:
  /// **'Save trip'**
  String get saveTrip;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @goFromHere.
  ///
  /// In en, this message translates to:
  /// **'Go from here'**
  String get goFromHere;

  /// No description provided for @goToHere.
  ///
  /// In en, this message translates to:
  /// **'Go to here'**
  String get goToHere;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavorites;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No trips planned yet'**
  String get noHistory;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Find Your Nearest Station'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In en, this message translates to:
  /// **'Instantly locate the closest metro station to you with GPS.'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Plan Any Trip'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In en, this message translates to:
  /// **'Plan your journey across all Cairo Metro lines with transfers.'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Works Fully Offline'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In en, this message translates to:
  /// **'No internet needed. All metro data is built into the app.'**
  String get onboarding3Desc;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @stops.
  ///
  /// In en, this message translates to:
  /// **'{count} stops'**
  String stops(int count);

  /// No description provided for @mapView.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapView;

  /// No description provided for @schematicView.
  ///
  /// In en, this message translates to:
  /// **'Diagram'**
  String get schematicView;

  /// No description provided for @allLines.
  ///
  /// In en, this message translates to:
  /// **'All Lines'**
  String get allLines;

  /// No description provided for @pickOnMap.
  ///
  /// In en, this message translates to:
  /// **'Pick on map'**
  String get pickOnMap;

  /// No description provided for @stationDetails.
  ///
  /// In en, this message translates to:
  /// **'Station Details'**
  String get stationDetails;

  /// No description provided for @linesServed.
  ///
  /// In en, this message translates to:
  /// **'Lines served'**
  String get linesServed;

  /// No description provided for @planFromHere.
  ///
  /// In en, this message translates to:
  /// **'Plan from here'**
  String get planFromHere;

  /// No description provided for @planToHere.
  ///
  /// In en, this message translates to:
  /// **'Plan to here'**
  String get planToHere;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for data updates'**
  String get checkForUpdates;

  /// No description provided for @dataUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Metro data is up to date'**
  String get dataUpToDate;

  /// No description provided for @tripSummary.
  ///
  /// In en, this message translates to:
  /// **'Trip Summary'**
  String get tripSummary;

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// No description provided for @directionToward.
  ///
  /// In en, this message translates to:
  /// **'Toward {station}'**
  String directionToward(String station);

  /// No description provided for @arrivalTime.
  ///
  /// In en, this message translates to:
  /// **'Est. arrival'**
  String get arrivalTime;

  /// No description provided for @departNow.
  ///
  /// In en, this message translates to:
  /// **'Depart now'**
  String get departNow;

  /// No description provided for @transfers.
  ///
  /// In en, this message translates to:
  /// **'{count} transfer(s)'**
  String transfers(int count);

  /// No description provided for @noTransfers.
  ///
  /// In en, this message translates to:
  /// **'Direct — no transfers'**
  String get noTransfers;

  /// No description provided for @showStops.
  ///
  /// In en, this message translates to:
  /// **'Show {count} stops'**
  String showStops(int count);

  /// No description provided for @hideStops.
  ///
  /// In en, this message translates to:
  /// **'Hide stops'**
  String get hideStops;

  /// No description provided for @transferWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk to {line} platform (~{minutes} min)'**
  String transferWalk(String line, int minutes);

  /// No description provided for @fareNote.
  ///
  /// In en, this message translates to:
  /// **'Ticket price as of 2025'**
  String get fareNote;

  /// No description provided for @totalDuration.
  ///
  /// In en, this message translates to:
  /// **'Total duration'**
  String get totalDuration;

  /// No description provided for @rideTime.
  ///
  /// In en, this message translates to:
  /// **'Ride time'**
  String get rideTime;

  /// No description provided for @walkTime.
  ///
  /// In en, this message translates to:
  /// **'Walk time'**
  String get walkTime;

  /// No description provided for @swapStations.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get swapStations;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppL10nAr();
    case 'en':
      return AppL10nEn();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
