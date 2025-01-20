import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:suvidhaorg/models/auth_models/login_request.dart';
import 'package:suvidhaorg/models/auth_models/register_request.dart';
import 'package:suvidhaorg/models/backend_response.dart';
import 'package:suvidhaorg/models/organization_model/org.dart';
import 'package:suvidhaorg/services/interceptors/token_interceptor.dart';
import '../models/organization_model/new_org.dart';
import 'interceptors/log_interceptor.dart';

class BackendService extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:4040/api",
    ),
  )
    ..interceptors.add(TokenInterceptor())
    ..interceptors.add(CustomLogInterceptor());

  Future<BackendResponse> registerOrg(RegisterRequest request) async {
    try {
      Response resp = await _dio.post(
        '/auth/registerorg',
        data: request.toJson(),
      );
      if (resp.statusCode != null) {
        BackendResponse response =
            BackendResponse.fromJson(resp.data, resp.statusCode!);
        return response;
      } else {
        throw Exception('Failed to register organization');
      }
    } catch (e) {
      debugPrint("Error in registering User :${e.toString()}");
      throw Exception('Failed to register user');
    }
  }

  // Login user
  Future<BackendResponse> loginUser(LoginRequest request) async {
    try {
      Response resp = await _dio.post(
        '/auth/login',
        data: request.toJson(),
      );

      if (resp.statusCode != null) {
        BackendResponse response =
            BackendResponse.fromJson(resp.data, resp.statusCode!);
        return response;
      } else {
        throw Exception('Failed to login user');
      }
    } catch (e) {
      debugPrint("Error while logging in: ${e.toString()}");
      throw Exception('Unable to login');
    }
  }

  // Verify email
  Future<BackendResponse> verifyEmail(
      {required String email, required num otp}) async {
    try {
      Response response = await _dio.post(
        '/auth/verifyEmail',
        data: {
          'email': email,
          'otp': otp,
        },
      );
      if (response.statusCode != null) {
        BackendResponse resp =
            BackendResponse.fromJson(response.data, response.statusCode!);
        return resp;
      } else {
        throw Exception('Failed to verify email');
      }
    } catch (e) {
      debugPrint("Error while verifying email :${e.toString()}");
      throw Exception('Unable to verify email');
    }
  }

  // Resend verification email
  Future<BackendResponse> resendVerificationEmail(
      {required String email}) async {
    try {
      Response response = await _dio.post(
        '/auth/resendVerificationEmail',
        data: {
          'email': email,
        },
      );
      if (response.statusCode != null) {
        BackendResponse resp =
            BackendResponse.fromJson(response.data, response.statusCode!);
        return resp;
      } else {
        throw Exception('Failed to resend verification email');
      }
    } catch (e) {
      debugPrint("Error while resending verification email :${e.toString()}");
      throw Exception('Unable to resend verification email');
    }
  }

  // Send forgot password request
  Future<BackendResponse> sendForgotPasswordRequest({
    required String email,
  }) async {
    try {
      Response response = await _dio.post(
        '/auth/forgetPassword',
        data: {
          'email': email,
        },
      );
      if (response.statusCode != null) {
        BackendResponse resp =
            BackendResponse.fromJson(response.data, response.statusCode!);
        return resp;
      } else {
        throw Exception('Failed to send forgot password request');
      }
    } catch (e) {
      debugPrint(
          "Error while sending forgot password request :${e.toString()}");
      throw Exception('Unable to send forgot password request');
    }
  }

  // Verify reset password token
  Future<BackendResponse> verifyResetPasswordToken({
    required String email,
    required num token,
  }) async {
    try {
      Response resp = await _dio.post('/auth/verifyOtp', data: {
        'email': email,
        'otp': token,
      });
      if (resp.statusCode != null) {
        BackendResponse response =
            BackendResponse.fromJson(resp.data, resp.statusCode!);
        return response;
      } else {
        throw Exception('Failed to verify reset password token');
      }
    } catch (e) {
      debugPrint("Error while verifying reset password token :${e.toString()}");
      throw Exception('Unable to verify reset password token');
    }
  }

  // Reset password
  Future<BackendResponse<Map<String, dynamic>>> resetPassword({
    required String email,
    required num token,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      Response resp = await _dio.post(
        '/auth/resetPassword',
        data: {
          'email': email,
          'otp': token,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );
      return BackendResponse<Map<String, dynamic>>(
        title: resp.data['title'] ?? '',
        message: resp.data['message'] ?? '',
        result: resp.data['title'] == 'error' ? null : resp.data['data'],
        statusCode: resp.statusCode,
      );
    } catch (e) {
      debugPrint("Error while resetting password :${e.toString()}");
      throw Exception('Unable to reset password');
    }
  }

  // Refresh token
  Future<BackendResponse<Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      Response response = await _dio.post(
        '/auth/refreshToken',
        data: {
          'refreshToken': refreshToken,
        },
      );
      return BackendResponse<Map<String, dynamic>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        result:
            response.data['title'] == 'error' ? null : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint("Error while refreshing token :${e.toString()}");
      throw Exception('Unable to refresh token');
    }
  }

  // Change password
  Future<BackendResponse<Map<String, dynamic>>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      Response resp = await _dio.post(
        '/auth/changePassword',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
      return BackendResponse<Map<String, dynamic>>(
        title: resp.data['title'] ?? '',
        message: resp.data['message'] ?? '',
        result: resp.data['title'] == 'error' ? null : resp.data['data'],
        statusCode: resp.statusCode,
      );
    } catch (e) {
      debugPrint("Error while changing password :${e.toString()}");
      throw Exception('Unable to change password');
    }
  }

  // Get user details
  Future<BackendResponse> getUserDetails() async {
    try {
      Response resp = await _dio.get('/auth/me');
      if (resp.statusCode != null) {
        BackendResponse response =
            BackendResponse.fromJson(resp.data, resp.statusCode!);
        return response;
      } else {
        throw Exception('Failed to get user details');
      }
    } catch (e) {
      debugPrint("Error while getting user details :${e.toString()}");
      throw Exception('Unable to get user details');
    }
  }
  //add fcm token

  Future<BackendResponse> addFcmToken({required String fcmToken}) async {
    try {
      Response response = await _dio.post(
        '/auth/addFcm',
        data: {
          'fcmToken': fcmToken,
        },
      );
      if (response.statusCode != null) {
        BackendResponse resp =
            BackendResponse.fromJson(response.data, response.statusCode!);
        return resp;
      } else {
        throw Exception('Failed to add fcm token');
      }
    } catch (e) {
      debugPrint("Error while adding fcm token :${e.toString()}");
      throw Exception('Unable to add fcm token');
    }
  }

  //remove fcm token
  Future<BackendResponse> removeFcmToken({required String fcmToken}) async {
    try {
      Response response =
          await _dio.post('/auth/removefcm', data: {'fcmToken': fcmToken});
      if (response.statusCode != null) {
        BackendResponse resp =
            BackendResponse.fromJson(response.data, response.statusCode!);
        return resp;
      } else {
        throw Exception('Failed to remove fcm token');
      }
    } catch (e) {
      debugPrint("Error while removing fcm token :${e.toString()}");
      throw Exception('Unable to remove fcm token');
    }
  }

// Post image method
  Future<BackendResponse> postImage({
    required File image,
  }) async {
    try {
      final imageName = image.path.split('/').last;

      final fileExtension = imageName.split('.').last.toLowerCase();
      final supportedFormats = ['jpg', 'jpeg', 'png'];
      if (!supportedFormats.contains(fileExtension)) {
        throw Exception('Unsupported file format: $fileExtension');
      }

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: imageName,
          contentType: MediaType('image', fileExtension),
        ),
      });

      Response response = await _dio.post(
        '/image/details',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode != null) {
        BackendResponse resp =
            BackendResponse.fromJson(response.data, response.statusCode!);
        return resp;
      } else {
        throw Exception('Failed to post image');
      }
    } catch (e) {
      debugPrint("Error while posting image: ${e.toString()}");
      throw Exception('Unable to post image');
    }
  }

  //get image

  Future<BackendResponse> getImage({required String imageUrl}) async {
    try {
      Response response =
          await _dio.get('/image/details', queryParameters: {'url': imageUrl});
      if (response.statusCode != null) {
        BackendResponse resp =
            BackendResponse.fromJson(response.data, response.statusCode!);
        return resp;
      } else {
        throw Exception('Failed to get image');
      }
    } catch (e) {
      debugPrint("Error while getting image :${e.toString()}");
      throw Exception('Unable to get image');
    }
  }

  //delete image
  Future<BackendResponse> deleteImage({required String imageUrl}) async {
    try {
      Response response = await _dio
          .delete('/image/details', queryParameters: {'url': imageUrl});
      if (response.statusCode != null) {
        BackendResponse resp =
            BackendResponse.fromJson(response.data, response.statusCode!);
        return resp;
      } else {
        throw Exception('Failed to delete image');
      }
    } catch (e) {
      debugPrint("Error while deleting image :${e.toString()}");
      throw Exception('Unable to delete image');
    }
  }

  //get all the service name

  Future<BackendResponse> getServiceNames() async {
    try {
      Response response = await _dio.get(
        '/service/serviceName',
      );
      if (response.statusCode != null) {
        BackendResponse resp =
            BackendResponse.fromJson(response.data, response.statusCode!);
        return resp;
      } else {
        throw Exception('Failed to get service names');
      }
    } catch (e) {
      debugPrint("Error while getting service names :${e.toString()}");
      throw Exception('Unable to get service names');
    }
  }

  //get service name by id

  Future<BackendResponse> getServiceName({required String serviceId}) async {
    try {
      Response response = await _dio
          .get('/service/serviceName/:id', queryParameters: {'id': serviceId});
      if (response.statusCode != null) {
        BackendResponse resp =
            BackendResponse.fromJson(response.data, response.statusCode!);
        return resp;
      } else {
        throw Exception('Failed to get service name');
      }
    } catch (e) {
      debugPrint("Error while fetching service name by id: ${e.toString()}");
      throw Exception('Unable to get service name');
    }
  }

  //create an organization control

  Future<BackendResponse> createOrganization(
      {required NewOrganization newOrg}) async {
    print(newOrg.toJson());
    try {
      Response response = await _dio.post(
        '/org',
        data: newOrg.toJson(),
      );

      if (response.statusCode != null) {
        BackendResponse resp =
            BackendResponse.fromJson(response.data, response.statusCode!);
        return resp;
      } else {
        throw Exception('Failed to create organization');
      }
    } catch (e) {
      debugPrint("Error while creating organization: ${e.toString()}");
      throw Exception('Unable to create organization: ${e.toString()}');
    }
  }

  //request for organization verification

  Future<BackendResponse> requestOrgVerification({
    required String orgId,
  }) async {
    try {
      Response response = await _dio.put(
        '/org/requestverification/$orgId', // Replace :id with $orgId
      );

      if (response.statusCode != null) {
        BackendResponse resp =
            BackendResponse.fromJson(response.data, response.statusCode!);
        return resp;
      } else {
        throw Exception('Failed to request organization verification');
      }
    } catch (e) {
      debugPrint(
          "Error while requesting organization verification: ${e.toString()}");
      throw Exception('Unable to request organization verification');
    }
  }

  //get organization by id

  Future<BackendResponse> getOrganizationById({required String orgId}) async {
    try {
      Response response = await _dio.get(
        '/org/$orgId',
      );
      if (response.statusCode != null) {
        BackendResponse resp =
            BackendResponse.fromJson(response.data, response.statusCode!);
        return resp;
      } else {
        throw Exception('Failed to get organization');
      }
    } catch (e) {
      debugPrint("Error while fetching organization by id: ${e.toString()}");
      throw Exception('Unable to get organization');
    }
  }

  //update org
  Future<BackendResponse<Map<String, dynamic>>> updateOrg(
      {required OrganizationModel organization}) async {
    try {
      Response response = await _dio.put(
        '/org',
        data: organization.toJson(),
      );

      return BackendResponse<Map<String, dynamic>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        result:
            response.data['title'] == 'error' ? null : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint("Error while updating organization: ${e.toString()}");
      throw Exception('Unable to update organization');
    }
  }

  //
}
