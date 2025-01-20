
class BackendResponse<T> {
  final String title;
  final String? message;
  final T? result;
  final int? statusCode;
  final String? errorMessage;

  BackendResponse({
    required this.title,
    this.message,
    this.result,
    this.statusCode,
    this.errorMessage,
  });

  factory BackendResponse.fromJson(Map<String, dynamic> json, int statusCode) {
    return BackendResponse(
      title: json['title'],
      message: statusCode == 200 ? json['message'] : null,
      result: json['data'],
      statusCode: statusCode,
      errorMessage: statusCode != 200 ? json['message'] : null,
    );
  }
}
