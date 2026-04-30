import 'package:equatable/equatable.dart';

abstract class UseCase<ReturnValue, Params extends Equatable> {
  const UseCase();
  Future<ReturnValue> call(Params params);
}

abstract class StreamUseCase<ReturnValue, Params extends Equatable> {
  const StreamUseCase();
  Stream<ReturnValue> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
