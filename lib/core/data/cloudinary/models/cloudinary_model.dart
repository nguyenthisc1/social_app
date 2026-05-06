import 'package:equatable/equatable.dart';

class CloudinaryUploadResultModel extends Equatable {
  final String url;
  final String publicId;
  final String? resourceType;
  final String? format;
  final int? bytes;

  const CloudinaryUploadResultModel({
    required this.url,
    required this.publicId,
    this.resourceType,
    this.format,
    this.bytes,
  });

  @override
  List<Object?> get props => [url, publicId, resourceType, format, bytes];

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'publicId': publicId,
      'resourceType': resourceType,
      'format': format,
      'bytes': bytes,
    };
  }

  factory CloudinaryUploadResultModel.fromJson(Map<String, dynamic> json) {
    return CloudinaryUploadResultModel(
      url: json['url'],
      publicId: json['publicId'],
      resourceType: json['resourceType'],
      format: json['format'],
      bytes: json['bytes'],
    );
  }

  CloudinaryUploadResultModel copyWith({
    String? url,
    String? publicId,
    String? resourceType,
    String? format,
    int? bytes,
  }) {
    return CloudinaryUploadResultModel(
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
      resourceType: resourceType ?? this.resourceType,
      format: format ?? this.format,
      bytes: bytes ?? this.bytes,
    );
  }
}
