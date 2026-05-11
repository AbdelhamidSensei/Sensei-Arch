import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepositoryImpl();
});

final isOnboardedProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(onboardingRepositoryProvider);
  return repo.isOnboarded();
});
