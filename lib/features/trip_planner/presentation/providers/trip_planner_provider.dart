import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../metro_data/domain/entities/station.dart';
import '../../../metro_data/presentation/providers/metro_provider.dart';
import '../../domain/entities/trip_plan.dart';
import '../../domain/usecases/plan_trip_usecase.dart';
import '../../../history/presentation/providers/history_provider.dart';

class TripPlannerState {
  final Station? fromStation;
  final Station? toStation;
  final bool isLoading;
  final String? error;
  final bool usingMyLocation;

  const TripPlannerState({
    this.fromStation,
    this.toStation,
    this.isLoading = false,
    this.error,
    this.usingMyLocation = false,
  });

  TripPlannerState copyWith({
    Station? Function()? fromStation,
    Station? Function()? toStation,
    bool? isLoading,
    String? Function()? error,
    bool? usingMyLocation,
  }) {
    return TripPlannerState(
      fromStation: fromStation != null ? fromStation() : this.fromStation,
      toStation: toStation != null ? toStation() : this.toStation,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
      usingMyLocation: usingMyLocation ?? this.usingMyLocation,
    );
  }
}

class TripPlannerNotifier extends StateNotifier<TripPlannerState> {
  final Ref _ref;

  TripPlannerNotifier(this._ref) : super(const TripPlannerState());

  void setFromStation(Station station) {
    state = state.copyWith(
      fromStation: () => station,
      error: () => null,
      usingMyLocation: false,
    );
  }

  void setToStation(Station station) {
    state = state.copyWith(
      toStation: () => station,
      error: () => null,
    );
  }

  Future<void> setFromStationById(String stationId) async {
    final repo = _ref.read(metroRepositoryProvider);
    final stations = await repo.getStations();
    final match = stations.where((s) => s.id == stationId);
    if (match.isNotEmpty) {
      setFromStation(match.first);
    }
  }

  Future<void> setToStationById(String stationId) async {
    final repo = _ref.read(metroRepositoryProvider);
    final stations = await repo.getStations();
    final match = stations.where((s) => s.id == stationId);
    if (match.isNotEmpty) {
      setToStation(match.first);
    }
  }

  Future<void> useMyLocationAsFrom() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      final repo = _ref.read(metroRepositoryProvider);
      final nearest =
          await repo.findNearestStation(position.latitude, position.longitude);
      if (nearest != null) {
        state = state.copyWith(
          fromStation: () => nearest,
          usingMyLocation: true,
          error: () => null,
        );
      }
    } catch (e) {
      state = state.copyWith(error: () => e.toString());
    }
  }

  Future<TripPlan?> planTrip() async {
    if (state.fromStation == null || state.toStation == null) return null;

    state = state.copyWith(isLoading: true, error: () => null);

    try {
      final repo = _ref.read(metroRepositoryProvider);
      final usecase = PlanTripUsecase(repo);
      final plan = await usecase.call(
        fromStationId: state.fromStation!.id,
        toStationId: state.toStation!.id,
      );

      state = state.copyWith(isLoading: false);

      if (plan != null) {
        // Save to history
        _ref.read(historyProvider.notifier).addTrip(
              fromStationId: plan.boardingStation.id,
              toStationId: plan.alightingStation.id,
              totalMinutes: plan.totalMinutes,
              totalStations: plan.totalStations,
              fareEGP: plan.fareEGP,
            );
      }

      return plan;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: () => e.toString(),
      );
      return null;
    }
  }
}

final tripPlannerProvider =
    StateNotifierProvider<TripPlannerNotifier, TripPlannerState>((ref) {
  return TripPlannerNotifier(ref);
});
