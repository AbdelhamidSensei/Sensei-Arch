extension StringX on String {
  String get stripDiacritics {
    return replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
  }

  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }

  bool matchesArabicOrEnglish(String query) {
    final q = query.stripDiacritics.toLowerCase();
    return stripDiacritics.toLowerCase().contains(q);
  }
}
