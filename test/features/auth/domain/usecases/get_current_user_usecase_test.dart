import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/auth/domain/usecases/get_current_user_usecase.dart';

import '../../../../helpers/test_helper.mocks.dart';
import '../../fixtures/auth_fixtures.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late GetCurrentUserUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = GetCurrentUserUseCase(mockAuthRepository);
  });

  group('GetCurrentUserUseCase', () {
    test('Case 1: returns user when repository returns UserEntity', () async {
      when(
        mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => fakeUserEntity);

      final result = await useCase(NoParams());

      expect(result, fakeUserEntity);
      verify(mockAuthRepository.getCurrentUser()).called(1);
    });

    test('Case 2: bubbles exception when repository throws', () async {
      final exception = Exception('some error');
      when(mockAuthRepository.getCurrentUser()).thenThrow(exception);

      expect(() => useCase(NoParams()), throwsA(same(exception)));
      verify(mockAuthRepository.getCurrentUser()).called(1);
    });
  });
}
