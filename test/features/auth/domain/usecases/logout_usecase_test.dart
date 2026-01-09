import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/auth/domain/usecases/logout_usecase.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LogoutUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LogoutUseCase(mockAuthRepository);
  });

  test('should logout successfully', () async {
    // arrange
    when(
      mockAuthRepository.logout(),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(null));
    verify(mockAuthRepository.logout());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return failure when logout fails', () async {
    // arrange
    when(mockAuthRepository.logout()).thenAnswer(
      (_) async => Left(CacheFailure(message: 'Failed to clear cache')),
    );

    // act
    final result = await usecase();

    // assert
    expect(result, const Left(CacheFailure(message: 'Failed to clear cache')));
    verify(mockAuthRepository.logout());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
