class BooleanResponse {
  final num statusCode;
  final String message;

  BooleanResponse({required this.statusCode, required this.message});

  factory BooleanResponse.fromJson(Map<String, dynamic> json) {
    return BooleanResponse(
      statusCode: json['code'],
      message: json['message'],
    );
  }
}
