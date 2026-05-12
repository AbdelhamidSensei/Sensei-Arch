import 'package:flutter_riverpod/flutter_riverpod.dart';

final stationSearchQueryProvider = StateProvider<String>((ref) => '');
final selectedLineFilterProvider = StateProvider<String?>((ref) => null);
