// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppL10nAr extends AppL10n {
  AppL10nAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مترو القاهرة';

  @override
  String get tagline => 'اضغط، خطط، اركب.';

  @override
  String get tabMap => 'الخريطة';

  @override
  String get tabPlan => 'خطّط';

  @override
  String get tabStations => 'المحطات';

  @override
  String get tabFavorites => 'المفضلة';

  @override
  String get tabSettings => 'الإعدادات';

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String get useMyLocation => 'استخدم موقعي';

  @override
  String get search => 'بحث…';

  @override
  String get nearestStation => 'أقرب محطة';

  @override
  String boardAt(String station) {
    return 'اركب من $station';
  }

  @override
  String alightAt(String station) {
    return 'انزل في $station';
  }

  @override
  String transferAt(String station) {
    return 'غيّر في $station';
  }

  @override
  String estimatedTime(int minutes) {
    return '≈ $minutes دقيقة';
  }

  @override
  String fare(int egp) {
    return 'السعر: $egp جنيه';
  }

  @override
  String stations(int count) {
    return '$count محطة';
  }

  @override
  String get planTrip => 'خطط رحلتك';

  @override
  String get noRoute => 'لم يتم العثور على مسار';

  @override
  String get locationPermissionDenied =>
      'يجب السماح بالوصول للموقع لإيجاد أقرب محطة.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String walkTo(int minutes, String station) {
    return 'امشِ $minutes دقيقة إلى $station';
  }

  @override
  String walkFrom(int minutes, String station) {
    return 'امشِ $minutes دقيقة من $station';
  }

  @override
  String totalSummary(int stations, int minutes, int fare) {
    return '$stations محطة · $minutes دقيقة · $fare جنيه';
  }

  @override
  String get saveTrip => 'حفظ الرحلة';

  @override
  String get share => 'مشاركة';

  @override
  String get goFromHere => 'انطلق من هنا';

  @override
  String get goToHere => 'اذهب إلى هنا';

  @override
  String get favorites => 'المفضلة';

  @override
  String get history => 'السجل';

  @override
  String get noFavorites => 'لا توجد مفضلات بعد';

  @override
  String get noHistory => 'لم تخطط لأي رحلة بعد';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get system => 'النظام';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get darkTheme => 'داكن';

  @override
  String get about => 'عن التطبيق';

  @override
  String version(String version) {
    return 'الإصدار $version';
  }

  @override
  String get onboarding1Title => 'اعثر على أقرب محطة';

  @override
  String get onboarding1Desc => 'حدد أقرب محطة مترو إليك فوراً باستخدام GPS.';

  @override
  String get onboarding2Title => 'خطط لأي رحلة';

  @override
  String get onboarding2Desc =>
      'خطط رحلتك عبر جميع خطوط مترو القاهرة مع التحويلات.';

  @override
  String get onboarding3Title => 'يعمل بدون إنترنت';

  @override
  String get onboarding3Desc =>
      'لا حاجة للإنترنت. جميع بيانات المترو مدمجة في التطبيق.';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get next => 'التالي';

  @override
  String get skip => 'تخطي';

  @override
  String get transfer => 'تحويل';

  @override
  String stops(int count) {
    return '$count محطة';
  }

  @override
  String get mapView => 'الخريطة';

  @override
  String get schematicView => 'المخطط';

  @override
  String get allLines => 'كل الخطوط';

  @override
  String get pickOnMap => 'اختر من الخريطة';

  @override
  String get stationDetails => 'تفاصيل المحطة';

  @override
  String get linesServed => 'الخطوط المتاحة';

  @override
  String get planFromHere => 'خطط من هنا';

  @override
  String get planToHere => 'خطط إلى هنا';

  @override
  String get addToFavorites => 'إضافة للمفضلة';

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String get checkForUpdates => 'التحقق من تحديث البيانات';

  @override
  String get dataUpToDate => 'بيانات المترو محدثة';

  @override
  String get tripSummary => 'ملخص الرحلة';

  @override
  String get direction => 'الاتجاه';

  @override
  String directionToward(String station) {
    return 'اتجاه $station';
  }

  @override
  String get arrivalTime => 'الوصول المتوقع';

  @override
  String get departNow => 'الانطلاق الآن';

  @override
  String transfers(int count) {
    return '$count تحويل';
  }

  @override
  String get noTransfers => 'مباشر — بدون تحويلات';

  @override
  String showStops(int count) {
    return 'عرض $count محطة';
  }

  @override
  String get hideStops => 'إخفاء المحطات';

  @override
  String transferWalk(String line, int minutes) {
    return 'امشِ إلى رصيف $line (~$minutes دقيقة)';
  }

  @override
  String get fareNote => 'سعر التذكرة اعتباراً من 2025';

  @override
  String get totalDuration => 'المدة الإجمالية';

  @override
  String get rideTime => 'وقت الركوب';

  @override
  String get walkTime => 'وقت المشي';

  @override
  String get swapStations => 'تبديل';
}
