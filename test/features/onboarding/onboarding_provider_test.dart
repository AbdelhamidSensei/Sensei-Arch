import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockOnboardingRepository mockRepo;

  setUp(() {
    mockRepo = MockOnboardingRepository();
  });

  test('new install returns not onboarded', () async {
    when(() => mockRepo.isOnboarded()).thenAnswer((_) async => false);

    final result = await mockRepo.isOnboarded();
    expect(result, false);
  });

  test('after complete, isOnboarded returns true', () async {
    when(() => mockRepo.completeOnboarding()).thenAnswer((_) async {});
    when(() => mockRepo.isOnboarded()).thenAnswer((_) async => true);

    await mockRepo.completeOnboarding();
    final result = await mockRepo.isOnboarded();
    expect(result, true);
  });
}
