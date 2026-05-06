import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:social_app/core/data/cloudinary/models/cloudinary_model.dart';

abstract interface class CloudinaryService {
  Future<CloudinaryUploadResultModel> uploadMedia(String filePath);
}

class ConfigCloudinaryService {
  static final ConfigCloudinaryService instance =
      ConfigCloudinaryService._internal();

  late final Cloudinary cloudinary;
  final String cloudName;
  final String uploadPreset;
  final String? folder;

  ConfigCloudinaryService._internal()
    // : cloudName = const String.fromEnvironment('CLOUDINARY_CLOUD_NAME'),
    //   uploadPreset = const String.fromEnvironment('CLOUDINARY_UPLOAD_PRESET'),
    //   folder = const String.fromEnvironment(
    //     'CLOUDINARY_UPLOAD_FOLDER',
    //   ).isEmpty
    //       ? null
    //       : const String.fromEnvironment('CLOUDINARY_UPLOAD_FOLDER') {
    // cloudinary = Cloudinary.fromCloudName(
    //   cloudName: cloudName,
    // );
    : cloudName = 'locket',
      uploadPreset = 'ml_default',
      folder = 'social' {
    cloudinary = Cloudinary.fromCloudName(cloudName: cloudName);
  }
}
