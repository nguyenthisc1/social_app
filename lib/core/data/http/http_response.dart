class HttpResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;

  HttpResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory HttpResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return HttpResponse<T>(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }
}
