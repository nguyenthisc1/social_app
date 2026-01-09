import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/features/auth/domain/usecases/check_auth_status_usecase.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late CheckAuthStatusUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = CheckAuthStatusUseCase(mockAuthRepository);
  });

  test('should return true when user is authenticated', () async {
    // arrange
    when(mockAuthRepository.isAuthenticated())
        .thenAnswer((_) async => true);

    // act
    final result = await usecase();

    // assert
    expect(result, true);
    verify(mockAuthRepository.isAuthenticated());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return false when user is not authenticated', () async {
    // arrange
    when(mockAuthRepository.isAuthenticated())
        .thenAnswer((_) async => false);

    // act
    final result = await usecase();

    // assert
    expect(result, false);
    verify(mockAuthRepository.isAuthenticated());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}

