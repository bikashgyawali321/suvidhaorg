import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CustomLogInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    debugPrint(
      '[REQ] ${options.method} - ${options.path} - ${options.queryParameters}',
    );
    options.extra['start'] = DateTime.now();
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final start = response.requestOptions.extra['start'];
    final end = DateTime.now();
    final duration = end.difference(start);

    debugPrint(
      '[${response.statusCode}] ${response.requestOptions.method} - ${response.requestOptions.path} - ${duration.inMilliseconds}ms',
    );
    super.onResponse(response, handler);
  }
}
