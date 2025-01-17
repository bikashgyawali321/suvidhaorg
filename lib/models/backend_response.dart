class BackendResponse<T> {
  final String title;
  final String message;
  final T? data;
  final int? statusCode;

  BackendResponse({
    required this.title,
    required this.message,
    this.data,
    this.statusCode,
  });

  factory BackendResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return BackendResponse<T>(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      data: (json['title'] == 'error')
          ? null
          : (json['data'] != null ? fromJsonT(json['data']) : null),
      statusCode: json['statusCode'],
    );
  }
}
