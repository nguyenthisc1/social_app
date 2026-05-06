class CloudinaryConfig {
  final String cloudName;
  final String uploadPreset;
  final String? folder;

  const CloudinaryConfig({
    required this.cloudName,
    required this.uploadPreset,
    this.folder,
  });

  String get uploadUrl => 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
}

enum UploadResourceType { image, video, raw, auto }

extension UploadResourceTypeX on UploadResourceType {
  String get value => switch (this) {
    UploadResourceType.image => 'image',
    UploadResourceType.video => 'video',
    UploadResourceType.raw => 'raw',
    UploadResourceType.auto => 'auto',
  };
}
