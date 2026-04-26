import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:social_app/features/user/data/datasources/remote/user_remote_data_source.dart';
import 'package:social_app/features/user/data/models/user_model.dart';
import 'package:social_app/features/user/domain/user_exceptions.dart';

class UserFirebaseDataSource implements UserRemoteDataSource {
  UserFirebaseDataSource({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Future<UserModel?> getUserById(String id) async {
    final doc = await _firestore.collection('users').doc(id).get();
    if (doc.exists && doc.data() != null) {
      final data = {...doc.data()!, 'id': doc.id};
      return UserModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<List<UserModel>> getUsersByIds(List<String> ids) async {
    final uniqueIds = ids.where((id) => id.isNotEmpty).toSet().toList();
    if (uniqueIds.isEmpty) {
      return const [];
    }

    final users = await Future.wait(
      uniqueIds.map((id) => _firestore.collection('users').doc(id).get()),
    );

    return users
        .where((doc) => doc.exists && doc.data() != null)
        .map((doc) => UserModel.fromJson({...doc.data()!, 'id': doc.id}))
        .toList();
  }

  @override
  Future<UserModel> getUserProfile() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw UserLoadException(
        userMessage: 'Unable to load user profile.',
        debugMessage: 'No authenticated user found.',
      );
    }
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data() != null) {
      final data = {...doc.data()!, 'id': doc.id};
      return UserModel.fromJson(data);
    }
    throw UserNotFoundException(
      debugMessage: 'User profile document not found for uid=${user.uid}.',
    );
  }

  @override
  Future<List<UserModel>> searchUser(String search) async {
    if (search.trim().isEmpty) return [];

    final querySnapshot = await _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: search)
        .where('username', isLessThanOrEqualTo: '$search\uf8ff')
        .get();

    return querySnapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()..addAll({'id': doc.id})))
        .toList();
  }

  @override
  Future<UserModel> updateUserProfile(UserModel user) async {
    final userId = user.id;
    if (userId.isEmpty) {
      throw UserUpdateException(
        userMessage: 'Unable to update user profile.',
        debugMessage: 'User ID is required for updating profile.',
      );
    }
    final data = user.toJson();
    await _firestore.collection('users').doc(userId).update(data);
    final updatedDoc = await _firestore.collection('users').doc(userId).get();
    if (updatedDoc.exists && updatedDoc.data() != null) {
      return UserModel.fromJson(
        updatedDoc.data()!..addAll({'id': updatedDoc.id}),
      );
    }
    throw UserUpdateException(
      debugMessage: 'Updated user document not found for userId=$userId.',
    );
  }
}
