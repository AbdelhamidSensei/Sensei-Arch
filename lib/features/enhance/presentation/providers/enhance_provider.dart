import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/env.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/replicate_api.dart';
import '../../data/repositories/enhancement_repository_impl.dart';
import '../../domain/entities/enhancement_job.dart';
import '../../domain/repositories/enhancement_repository.dart';

final enhancementRepositoryProvider = Provider<EnhancementRepository>((ref) {
  if (!Env.hasApiToken) {
    return MockEnhancementRepository();
  }
  final dio = ref.watch(dioProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return EnhancementRepositoryImpl(ReplicateApi(dio), networkInfo);
});

final enhanceStateProvider =
    StateNotifierProvider<EnhanceNotifier, EnhanceState>((ref) {
  final repo = ref.watch(enhancementRepositoryProvider);
  return EnhanceNotifier(repo);
});

class EnhanceState {
  final String? imagePath;
  final EnhancementMode mode;
  final EnhancementJob? currentJob;
  final String? resultPath;
  final String? error;
  final bool isProcessing;

  const EnhanceState({
    this.imagePath,
    this.mode = EnhancementMode.enhance,
    this.currentJob,
    this.resultPath,
    this.error,
    this.isProcessing = false,
  });

  EnhanceState copyWith({
    String? imagePath,
    EnhancementMode? mode,
    EnhancementJob? currentJob,
    String? resultPath,
    String? error,
    bool? isProcessing,
  }) {
    return EnhanceState(
      imagePath: imagePath ?? this.imagePath,
      mode: mode ?? this.mode,
      currentJob: currentJob ?? this.currentJob,
      resultPath: resultPath ?? this.resultPath,
      error: error,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class EnhanceNotifier extends StateNotifier<EnhanceState> {
  final EnhancementRepository _repo;

  EnhanceNotifier(this._repo) : super(const EnhanceState());

  void setImage(String path) {
    state = state.copyWith(imagePath: path);
  }

  void setMode(EnhancementMode mode) {
    state = state.copyWith(mode: mode);
  }

  Future<void> startEnhancement() async {
    if (state.imagePath == null) return;

    state = state.copyWith(isProcessing: true, error: null);

    try {
      final job = await _repo.startEnhancement(
        localImagePath: state.imagePath!,
        mode: state.mode,
      );
      state = state.copyWith(currentJob: job);

      // If job already succeeded (e.g. Remove.bg returns instantly)
      if (job.isSucceeded && job.outputUrl != null) {
        final resultPath =
            await _repo.downloadResultToCache(job.outputUrl!);
        state = state.copyWith(
          resultPath: resultPath,
          isProcessing: false,
        );
        return;
      }

      await for (final update in _repo.pollStatus(job.id, state.mode)) {
        state = state.copyWith(currentJob: update);

        if (update.isSucceeded && update.outputUrl != null) {
          final resultPath =
              await _repo.downloadResultToCache(update.outputUrl!);
          state = state.copyWith(
            resultPath: resultPath,
            isProcessing: false,
          );
          return;
        }

        if (update.isFailed) {
          state = state.copyWith(
            error: update.error ?? 'Enhancement failed',
            isProcessing: false,
          );
          return;
        }
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isProcessing: false,
      );
    }
  }

  void reset() {
    state = const EnhanceState();
  }
}
