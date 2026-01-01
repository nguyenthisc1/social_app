import 'package:social_app/core/entities/author_entity.dart';

class AuthorModel extends Author {
  const AuthorModel({required super.id, required super.username});

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(id: json['id'] ?? json['_id'], username: json['username']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username};
  }

  factory AuthorModel.fromEntity(Author author) {
    return AuthorModel(id: author.id, username: author.username);
  }

  Author toEntity() {
    return Author(id: id, username: username);
  }
}
