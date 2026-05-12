import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapViewModeProvider = StateProvider<MapViewMode>((ref) => MapViewMode.osm);

enum MapViewMode { osm, schematic }
