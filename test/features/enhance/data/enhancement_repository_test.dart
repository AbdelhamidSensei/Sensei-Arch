import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photo_revive_ai/core/errors/exceptions.dart';
import 'package:photo_revive_ai/features/enhance/data/repositories/enhancement_repository_impl.dart';
import 'package:photo_revive_ai/features/enhance/domain/entities/enhancement_job.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockReplicateApi mockApi;
  late MockNetworkInfo mockNetwork;
  late EnhancementRepositoryImpl repo;

  setUp(() {
    mockApi = MockReplicateApi();
    mockNetwork = MockNetworkInfo();
    repo = EnhancementRepositoryImpl(mockApi, mockNetwork);
  });

  group('startEnhancement', () {
    test('throws NetworkException when offline', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      expect(
        () => repo.startEnhancement(
          localImagePath: '/fake/path.jpg',
          mode: EnhancementMode.enhance,
        ),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('MockEnhancementRepository', () {
    test('returns mock result without API', () async {
      final mockRepo = MockEnhancementRepository();

      final job = await mockRepo.startEnhancement(
        localImagePath: '/test/image.jpg',
        mode: EnhancementMode.enhance,
      );

      expect(job.id, startsWith('mock-'));
      expect(job.status, 'starting');
    });

    test('pollStatus emits processing then succeeded', () async {
      final mockRepo = MockEnhancementRepository();
      final events = await mockRepo
          .pollStatus('mock-1', EnhancementMode.enhance)
          .toList();

      expect(events.length, 2);
      expect(events[0].status, 'processing');
      expect(events[1].status, 'succeeded');
    });
  });
}
