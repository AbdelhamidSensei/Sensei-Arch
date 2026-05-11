import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photo_revive_ai/core/network/network_info.dart';
import 'package:photo_revive_ai/features/enhance/data/datasources/replicate_api.dart';
import 'package:photo_revive_ai/features/enhance/domain/repositories/enhancement_repository.dart';
import 'package:photo_revive_ai/features/history/domain/repositories/history_repository.dart';
import 'package:photo_revive_ai/features/onboarding/domain/repositories/onboarding_repository.dart';

class MockDio extends Mock implements Dio {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockReplicateApi extends Mock implements ReplicateApi {}

class MockEnhancementRepo extends Mock implements EnhancementRepository {}

class MockHistoryRepository extends Mock implements HistoryRepository {}

class MockOnboardingRepository extends Mock implements OnboardingRepository {}
