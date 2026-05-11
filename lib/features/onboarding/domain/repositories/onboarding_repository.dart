abstract class OnboardingRepository {
  Future<bool> isOnboarded();
  Future<void> completeOnboarding();
}
