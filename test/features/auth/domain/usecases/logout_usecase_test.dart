import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/auth/domain/usecases/logout_usecase.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late LogoutUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LogoutUseCase(mockAuthRepository);
  });

  group('LogoutUseCase', () {
    test(
      'Case 1: calls repository.logout when repository logout success',
      () async {
        when(mockAuthRepository.logout()).thenAnswer((_) async {});

        await useCase(NoParams());

        verify(mockAuthRepository.logout()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test('Case 2: bubble exception when repository logout fail', () async {
      final exception = Exception('Logout failed');
      when(mockAuthRepository.logout()).thenThrow(exception);

      expect(() => useCase(NoParams()), throwsA(same(exception)));

      verify(mockAuthRepository.logout()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
