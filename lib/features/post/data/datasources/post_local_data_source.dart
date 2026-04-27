import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/features/post/data/models/post_model.dart';

/// Local data source for post caching
abstract class PostLocalDataSource {
  Future<void> cachePosts(List<PostModel> posts);
  Future<List<PostModel>?> getCachedPosts();
  Future<void> clearCachedPosts();
}

const _cachedPostsKey = 'CACHED_POSTS';

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    final List<String> newPostJsonList = posts
        .map((post) => json.encode(post.toJson()))
        .toList();

    final List<String> existingPosts =
        sharedPreferences.getStringList(_cachedPostsKey) ?? [];

    final List<String> combinedPosts = [...newPostJsonList, ...existingPosts];

    // Limit to a maximum of 50 posts
    final List<String> limitedPosts = combinedPosts.take(50).toList();

    await sharedPreferences.setStringList(_cachedPostsKey, limitedPosts);
  }

  @override
  Future<List<PostModel>?> getCachedPosts() async {
    final List<String>? postJsonList = sharedPreferences.getStringList(
      _cachedPostsKey,
    );
    if (postJsonList == null) return null;
    return postJsonList
        .map((postJson) => PostModel.fromJson(json.decode(postJson)))
        .toList();
  }

  @override
  Future<void> clearCachedPosts() async {
    await sharedPreferences.remove(_cachedPostsKey);
  }
}
