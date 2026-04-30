import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/auth/domain/usecases/check_auth_status_usecase.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late CheckAuthStatusUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = CheckAuthStatusUseCase(mockAuthRepository);
  });

  group('CheckAuthStatusUseCase', () {
    test('Case 1: repository => true, use case => true', () async {
      // Given
      when(mockAuthRepository.isAuthenticated()).thenAnswer((_) async => true);

      // When
      final result = await useCase(NoParams());

      // Then
      expect(result, true);
      verify(mockAuthRepository.isAuthenticated()).called(1);
    });

    test('Case 2: repository => false, use case => false', () async {
      // Given
      when(mockAuthRepository.isAuthenticated()).thenAnswer((_) async => false);

      // When
      final result = await useCase(NoParams());

      // Then
      expect(result, false);
      verify(mockAuthRepository.isAuthenticated()).called(1);
    });
  });
}
