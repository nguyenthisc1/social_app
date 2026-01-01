import 'package:equatable/equatable.dart';

class Author extends Equatable {
  final String id;
  final String username;

  const Author({required this.id, required this.username});

  Author copyWith({String? id, String? username}) {
    return Author(id: id ?? this.id, username: username ?? this.username);
  }

  @override
  List<Object?> get props => [id, username];

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(id: json['id'], username: json['username']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username};
  }
}
