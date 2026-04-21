import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class CreatePostNewsWidget extends StatefulWidget {
  const CreatePostNewsWidget({super.key});

  @override
  _CreatePostNewsWidgetState createState() => _CreatePostNewsWidgetState();
}

class _CreatePostNewsWidgetState extends State<CreatePostNewsWidget> {
  List<AssetEntity> images = [];

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<bool> requestPermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    return ps.isAuth;
  }

  Future<void> loadImages() async {
    final hasPermission = await requestPermission();
    if (!hasPermission) return;

    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);

    final recentAlbum = albums.first;

    final media = await recentAlbum.getAssetListPaged(
      page: 0,
      size: 100, // load 100 ảnh đầu
    );

    setState(() {
      images = media;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return FutureBuilder<Uint8List?>(
          future: images[index].thumbnailDataWithSize(
            const ThumbnailSize(200, 200),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          },
        );
      },
    );
  }
}
