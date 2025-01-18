import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:suvidhaorg/models/auth_models/login_request.dart';
import 'package:suvidhaorg/models/auth_models/register_request.dart';
import 'package:suvidhaorg/models/backend_response.dart';
import 'package:suvidhaorg/services/interceptors/token_interceptor.dart';
import '../models/order_models/new_order.dart';
import '../models/organization_model/new_org.dart';
import 'interceptors/log_interceptor.dart';

class BackendService extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:4040/api",
      headers: {"Content-Type": "application/json"},
    ),
  )
    ..interceptors.add(TokenInterceptor())
    ..interceptors.add(CustomLogInterceptor());

  // Register user
  Future<BackendResponse<Map<String, dynamic>>> registerOrg(
      RegisterRequest request) async {
    try {
      Response response = await _dio.post(
        '/auth/registerorg',
        data: request.toJson(),
      );
      return BackendResponse<Map<String, dynamic>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        data: response.data['title'] == 'error' ? null : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint("Error in registering User :${e.toString()}");
      throw Exception('Failed to register user');
    }
  }

  // Login user
  Future<BackendResponse<Map<String, dynamic>>> loginUser(
      LoginRequest request) async {
    try {
      Response response = await _dio.post(
        '/auth/login',
        data: request.toJson(),
      );
      return BackendResponse<Map<String, dynamic>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        data: response.data['title'] == 'error' ? null : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint("Error while logging in: ${e.toString()}");
      throw Exception('Unable to login');
    }
  }

  // Verify email
  Future<BackendResponse<Map<String, dynamic>>> verifyEmail(
      {required String email, required num otp}) async {
    try {
      Response response = await _dio.post(
        '/auth/verifyEmail',
        data: {
          'email': email,
          'otp': otp,
        },
      );
      return BackendResponse<Map<String, dynamic>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        data: response.data['title'] == 'error' ? null : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint("Error while verifying email :${e.toString()}");
      throw Exception('Unable to verify email');
    }
  }

  // Resend verification email
  Future<BackendResponse<Map<String, dynamic>>> resendVerificationEmail(
      {required String email}) async {
    try {
      Response response = await _dio.post(
        '/auth/resendVerificationEmail',
        data: {
          'email': email,
        },
      );
      return BackendResponse<Map<String, dynamic>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        data: response.data['title'] == 'error' ? null : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint("Error while resending verification email :${e.toString()}");
      throw Exception('Unable to resend verification email');
    }
  }

  // Send forgot password request
  Future<BackendResponse<Map<String, dynamic>>> sendForgotPasswordRequest({
    required String email,
  }) async {
    try {
      Response response = await _dio.post(
        '/auth/forgetPassword',
        data: {
          'email': email,
        },
      );
      return BackendResponse<Map<String, dynamic>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        data: response.data['title'] == 'error' ? null : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint(
          "Error while sending forgot password request :${e.toString()}");
      throw Exception('Unable to send forgot password request');
    }
  }

  // Verify reset password token
  Future<BackendResponse<Map<String, dynamic>>> verifyResetPasswordToken({
    required String email,
    required num token,
  }) async {
    try {
      Response resp = await _dio.post('/auth/verifyOtp', data: {
        'email': email,
        'otp': token,
      });
      return BackendResponse<Map<String, dynamic>>(
        title: resp.data['title'] ?? '',
        message: resp.data['message'] ?? '',
        data: resp.data['title'] == 'error' ? null : resp.data['data'],
        statusCode: resp.statusCode,
      );
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
        data: resp.data['title'] == 'error' ? null : resp.data['data'],
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
        data: response.data['title'] == 'error' ? null : response.data['data'],
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
        data: resp.data['title'] == 'error' ? null : resp.data['data'],
        statusCode: resp.statusCode,
      );
    } catch (e) {
      debugPrint("Error while changing password :${e.toString()}");
      throw Exception('Unable to change password');
    }
  }

  // Get user details
  Future<BackendResponse<Map<String, dynamic>>> getUserDetails () async {
    try {
      Response response = await _dio.get('/auth/me');
      return BackendResponse<Map<String, dynamic>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        data: response.data['title'] == 'error' ? null : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint("Error while getting user details :${e.toString()}");
      throw Exception('Unable to get user details');
    }
  }
  //add fcm token

  Future<BackendResponse<Map<String,dynamic>>> addFcmToken({required String fcmToken}) async {
    try {
      Response response = await _dio.post(
        '/auth/addFcm',
        data: {
          'fcmToken': fcmToken,
        },
      );
      return BackendResponse<Map<String,dynamic>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        data: response.data['title'] == 'error' ? null : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint("Error while adding fcm token :${e.toString()}");
      throw Exception('Unable to add fcm token');
    }
  }

  //remove fcm token
  Future<BackendResponse<Map<String,dynamic>>> removeFcmToken({required String fcmToken}) async {
    try {
      Response response = await _dio.post(
        '/auth/removefcm',
        data: {
          'fcmToken':fcmToken
        }
      );
      return BackendResponse<Map<String,dynamic>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        data: response.data['title'] == 'error' ? null : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint("Error while removing fcm token :${e.toString()}");
      throw Exception('Unable to remove fcm token');
    }
  }



  //post image
  Future<BackendResponse<Map<String,dynamic>>> postImage({required File image,required String imageType}) async {
    try {
      final FormData formData = FormData.fromMap({
        'data': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
        "type":imageType

      });
      Response response = await _dio.post(
        '/image/details',
        data:formData,
      );
      return BackendResponse<Map<String,dynamic>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        data: response.data['title'] == 'error' ? null : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint("Error while posting image :${e.toString()}");
      throw Exception('Unable to post image');
    }
  }
   

  //get image

  Future<BackendResponse<Map<String,dynamic>>> getImage({required String imageUrl}) async {
    try {
      Response response = await _dio.get(
        '/image/details',
        queryParameters: {                                                               
          'url':imageUrl
        }
      );
      return BackendResponse<Map<String,dynamic>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        data: response.data['title'] == 'error' ? null : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint("Error while getting image :${e.toString()}");
      throw Exception('Unable to get image');
    }
  }

  //delete image
  Future<BackendResponse<Map<String,dynamic>>> deleteImage({required String imageUrl}) async {
    try {
      Response response = await _dio.delete(
        '/image/details',
          queryParameters: {
          'url':imageUrl
        }
      );
      return BackendResponse<Map<String,dynamic>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        data: response.data['title'] == 'error' ? null : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint("Error while deleting image :${e.toString()}");
      throw Exception('Unable to delete image');
    }
  }
  

  //get all the service name

  Future<BackendResponse<List<Map<String,dynamic>>>> getServiceNames() async {
    try {
      Response response = await _dio.get(
        '/service/serviceName',
      );
      return BackendResponse<List<Map<String,dynamic>>>(
        title: response.data['title'] ?? '',
        message: response.data['message'] ?? '',
        data: response.data['title'] == 'error' ? [] : response.data['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint("Error while getting service names :${e.toString()}");
      throw Exception('Unable to get service names');
    }
  }

  //get service name by id

  Future<BackendResponse<Map<String,dynamic>>> getServiceName({required String serviceId})async{

    try {
         Response response= await _dio.get('/service/serviceName/:id',
             queryParameters: {
              'id':serviceId
             }
         
         );

          return BackendResponse<Map<String,dynamic>>(
            message: response.data['message']??'',
            title: response.data['message']??'',
                 data: response.data['title'] == 'error' ? [] : response.data['data'],
        statusCode: response.statusCode,

          );
    } catch (e) {
      debugPrint("Error while fetching service name by id: ${e.toString()}");
      throw Exception('Unable to get service name');

      
    } 
  }
 

 //create an organization control

 Future<BackendResponse<Map<String,dynamic>>> createOrganization({ required NewOrganization newOrg }) async{
  try{
    Response response= await _dio.post('/org',
    data: newOrg.toJson()
    );

    return BackendResponse<Map<String,dynamic>>(
      title: response.data['title']??'',
      message: response.data['message']??'',
      data: response.data['title'] == 'error' ? null : response.data['data'],
      statusCode: response.statusCode,
    );
  }
  catch(e){
    debugPrint("Error while creating organization: ${e.toString()}");
    throw Exception('Unable to create organization: ${e.toString()}');
  }
 }
 }