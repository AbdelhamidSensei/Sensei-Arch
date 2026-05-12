class Station {
  final String id;
  final String nameEn;
  final String nameAr;
  final double lat;
  final double lng;
  final List<String> lineIds;
  final bool isTransfer;

  const Station({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.lat,
    required this.lng,
    required this.lineIds,
    this.isTransfer = false,
  });

  String localizedName(String languageCode) =>
      languageCode == 'ar' ? nameAr : nameEn;

  factory Station.fromJson(Map<String, dynamic> json) => Station(
        id: json['id'] as String,
        nameEn: json['nameEn'] as String,
        nameAr: json['nameAr'] as String,
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        lineIds: (json['lineIds'] as List).cast<String>(),
        isTransfer: json['isTransfer'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameEn': nameEn,
        'nameAr': nameAr,
        'lat': lat,
        'lng': lng,
        'lineIds': lineIds,
        'isTransfer': isTransfer,
      };
}
