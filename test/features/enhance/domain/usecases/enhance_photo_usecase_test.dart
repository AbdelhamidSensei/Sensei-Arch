import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photo_revive_ai/features/enhance/domain/entities/enhancement_job.dart';
import 'package:photo_revive_ai/features/enhance/domain/usecases/enhance_photo_usecase.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late MockEnhancementRepo mockRepo;
  late EnhancePhotoUseCase useCase;

  setUpAll(() {
    registerFallbackValue(EnhancementMode.enhance);
  });

  setUp(() {
    mockRepo = MockEnhancementRepo();
    useCase = EnhancePhotoUseCase(mockRepo);
  });

  test('calls repository with correct mode', () async {
    when(() => mockRepo.startEnhancement(
          localImagePath: any(named: 'localImagePath'),
          mode: any(named: 'mode'),
        )).thenAnswer((_) async => TestData.successJob);

    final result = await useCase(
      localImagePath: '/test.jpg',
      mode: EnhancementMode.enhance,
    );

    expect(result.id, 'test-123');
    verify(() => mockRepo.startEnhancement(
          localImagePath: '/test.jpg',
          mode: EnhancementMode.enhance,
        )).called(1);
  });

  test('propagates errors', () async {
    when(() => mockRepo.startEnhancement(
          localImagePath: any(named: 'localImagePath'),
          mode: any(named: 'mode'),
        )).thenThrow(Exception('fail'));

    expect(
      () => useCase(
          localImagePath: '/test.jpg', mode: EnhancementMode.enhance),
      throwsA(isA<Exception>()),
    );
  });
}
