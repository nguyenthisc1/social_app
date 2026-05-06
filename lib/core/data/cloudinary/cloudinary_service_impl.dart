import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:social_app/core/data/cloudinary/cloudinary_service.dart';
import 'package:social_app/core/data/cloudinary/models/cloudinary_model.dart';
import 'package:social_app/core/data/cloudinary/models/cloudinary_types.dart';
import 'package:social_app/core/domain/exceptions/generic_exception.dart';

class CloudinaryServiceImpl implements CloudinaryService {
  const CloudinaryServiceImpl({
    required ConfigCloudinaryService cloudinaryService,
  }) : _cloudinaryService = cloudinaryService;

  final ConfigCloudinaryService _cloudinaryService;

  @override
  Future<CloudinaryUploadResultModel> uploadMedia(String filePath) async {
    final config = CloudinaryConfig(
      cloudName: _cloudinaryService.cloudName,
      uploadPreset: _cloudinaryService.uploadPreset,
      folder: _cloudinaryService.folder,
    );


    if (config.cloudName.isEmpty || config.uploadPreset.isEmpty) {
      throw ServerException(
        userMessage: 'Image upload is not configured.',
        debugMessage:
            'Cloudinary configuration is missing cloudName or uploadPreset.',
      );
    }

    final file = File(filePath);
    if (!await file.exists()) {
      throw NotFoundException(
        userMessage: 'Selected image file could not be found.',
        debugMessage: 'Cloudinary upload file does not exist: $filePath',
      );
    }

    final uri = Uri.parse(config.uploadUrl);
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = config.uploadPreset;

    if (config.folder?.isNotEmpty == true) {
      request.fields['folder'] = config.folder!;
    }

    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final statusCode = response.statusCode;
      final data = response.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body) as Map<String, dynamic>;

      if (statusCode < 200 || statusCode >= 300) {
        throw ServerException(
          userMessage:
              data['error']?['message']?.toString() ?? 'Image upload failed.',
          debugMessage:
              'Cloudinary upload failed with status=$statusCode body=${response.body}',
          cause: statusCode,
        );
      }

      final secureUrl =
          data['secure_url']?.toString() ?? data['url']?.toString();
      final publicId = data['public_id']?.toString();

      if (secureUrl == null || secureUrl.isEmpty || publicId == null) {
        throw ServerException(
          userMessage: 'Image upload returned an invalid response.',
          debugMessage:
              'Cloudinary response missing secure_url/public_id: ${response.body}',
        );
      }

      return CloudinaryUploadResultModel(
        url: secureUrl,
        publicId: publicId,
        format: data['format']?.toString(),
        resourceType: data['resource_type']?.toString(),
        bytes: data['bytes'] is int
            ? data['bytes'] as int
            : int.tryParse(data['bytes']?.toString() ?? ''),
      );
    } on SocketException catch (error) {
      throw NetworkException(
        userMessage: 'No internet connection.',
        debugMessage: 'Cloudinary upload socket error.',
        cause: error,
      );
    } on http.ClientException catch (error) {
      throw NetworkException(
        userMessage: 'Unable to reach upload server.',
        debugMessage: 'Cloudinary upload client exception.',
        cause: error,
      );
    } on FormatException catch (error) {
      throw ServerException(
        userMessage: 'Image upload returned invalid data.',
        debugMessage: 'Failed to parse Cloudinary response JSON.',
        cause: error,
      );
    }
  }
}
