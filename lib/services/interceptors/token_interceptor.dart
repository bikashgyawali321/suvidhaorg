import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:suvidhaorg/models/auth_models/auth_token.dart';
import 'package:suvidhaorg/services/backend_service.dart';
import 'package:suvidhaorg/services/custom_hive.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    //auth token from device storage
    AuthToken? token = CustomHive().getAuthToken();

    if (token == null) {
      return handler.next(options);
    }

    // Decode the access token to extract the expiry date
    Map<String, dynamic> decodedAccessToken =
        JwtDecoder.decode(token.accessToken!);

    // Extract the expiry date from the JWT
    DateTime accessTokenExpiresAt =
        DateTime.fromMillisecondsSinceEpoch(decodedAccessToken['exp'] * 1000);

    // Token is still valid
    if (accessTokenExpiresAt.isAfter(DateTime.now())) {
      options.headers.addAll({
        "Authorization": "Bearer ${token.accessToken}",
      });
      return handler.next(options);
    }

    // If token is expired and not trying to refresh
    if (!options.path.contains('refreshToken')) {
      try {
        // Refresh token using the stored refresh token
        final response = await BackendService()
            .refreshToken(refreshToken: token.refreshToken!);

        if (response.result != null) {
          AuthToken newToken = AuthToken.fromJson(response.result!);
          // Save new token to Hive
          await CustomHive().saveAuthToken(newToken);
          options.headers.addAll({
            "Authorization": "Bearer ${newToken.accessToken}",
          });
        } else {
          // If refresh failed, delete the token
          await CustomHive().deleteToken();
        }
      } catch (e) {
        await CustomHive().deleteToken();
      }
    }

    return handler.next(options);
  }
}
