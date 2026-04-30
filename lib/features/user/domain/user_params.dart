import 'package:equatable/equatable.dart';

class GetUserByIdQuery extends Equatable {
  final String id;

  const GetUserByIdQuery({required this.id});

  @override
  List<Object?> get props => [id];
}
