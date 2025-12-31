class BaseResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;

  const BaseResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return BaseResponse<T>(
      success: json['success'] ?? false,
      message: json['message']?.toString(),
      data: fromJsonT != null ? fromJsonT(json['data']) : json['data'],
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }
}
