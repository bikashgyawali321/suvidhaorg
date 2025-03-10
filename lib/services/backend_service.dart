import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:suvidhaorg/models/auth_models/login_request.dart';
import 'package:suvidhaorg/models/auth_models/register_request.dart';
import 'package:suvidhaorg/models/backend_response.dart';
import 'package:suvidhaorg/services/interceptors/token_interceptor.dart';
import '../models/organization_model/new_org.dart';
import '../models/pagination/list_model.dart';
import '../models/service_model/new_service.dart';
import 'interceptors/log_interceptor.dart';

class BackendService extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          "https://suvidha-3.onrender.com/api", //https://suvidha-3.onrender.com/api
    ),
  )
    ..interceptors.add(TokenInterceptor())
    ..interceptors.add(CustomLogInterceptor());

  //custom request handler for all methods

  Future<BackendResponse> handleRequest(
      {required Future<Response> request,
      required String titleOfRequest}) async {
    try {
      final res = await request;
      return BackendResponse(
        title: res.data['title'],
        message: res.data['message'],
        result: res.data['data'],
        statusCode: res.statusCode,
      );
    } on DioError catch (dioError) {
      if (dioError.response != null) {
        debugPrint(
            "Server responded with error while $titleOfRequest: ${dioError.response?.data}");
        return BackendResponse(
          title: dioError.response?.data['title'] ?? '',
          result: dioError.response?.data['data'],
          statusCode: dioError.response?.statusCode,
          errorMessage: dioError.response?.data['message'],
        );
      } else {
        debugPrint(
            "Request failed with error while $titleOfRequest: ${dioError.message}");
        throw Exception(
            'Unable to process request $titleOfRequest: ${dioError.message}');
      }
    } catch (e) {
      debugPrint(
          "Request failed with error while $titleOfRequest: ${e.toString()}");
      throw Exception(
          'Unable to process request $titleOfRequest: ${e.toString()}');
    }
  }

//register organization
  Future<BackendResponse> registerOrg(RegisterRequest request) async {
    return await handleRequest(
      request: _dio.post('/auth/registerorg', data: request.toJson()),
      titleOfRequest: 'registering organization',
    );
  }

  // Login user
  Future<BackendResponse> login(LoginRequest request) async {
    return await handleRequest(
      request: _dio.post('/auth/login', data: request.toJson()),
      titleOfRequest: 'logging in',
    );
  }

  // Verify email
  Future<BackendResponse> verifyEmail(
      {required String email, required num otp}) async {
    return await handleRequest(
      request: _dio.post('/auth/verifyEmail', data: {
        'email': email,
        'otp': otp,
      }),
      titleOfRequest: 'verifying email',
    );
  }

  // Resend verification email
  Future<BackendResponse> resendVerificationEmail(
      {required String email}) async {
    return await handleRequest(
      request: _dio.post(
        '/auth/resendVerificationEmail',
        data: {
          'email': email,
        },
      ),
      titleOfRequest: 'resending verification email',
    );
  }

  // Send forgot password request
  Future<BackendResponse> sendForgotPasswordRequest({
    required String email,
  }) async {
    return await handleRequest(
      request: _dio.post(
        '/auth/forgetPassword',
        data: {
          'email': email,
        },
      ),
      titleOfRequest: 'sending forgot password request',
    );
  }

  // Verify reset password token
  Future<BackendResponse> verifyResetPasswordToken({
    required String email,
    required num token,
  }) async {
    return await handleRequest(
      request: _dio.post('/auth/verifyOtp', data: {
        'email': email,
        'otp': token,
      }),
      titleOfRequest: 'verifying reset password token',
    );
  }

  // Reset password
  Future<BackendResponse> resetPassword({
    required String email,
    required num token,
    required String password,
    required String confirmPassword,
  }) async {
    return await handleRequest(
      request: _dio.post(
        '/auth/resetPassword',
        data: {
          'email': email,
          'otp': token,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      ),
      titleOfRequest: 'resetting password',
    );
  }

  // Refresh token
  Future<BackendResponse> refreshToken({
    required String refreshToken,
  }) async {
    return await handleRequest(
      request: _dio.post(
        '/auth/refreshToken',
        data: {
          'refreshToken': refreshToken,
        },
      ),
      titleOfRequest: 'refreshing token',
    );
  }

  // Change password
  Future<BackendResponse> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await handleRequest(
      request: _dio.post(
        '/auth/changePassword',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      ),
      titleOfRequest: 'changing password',
    );
  }

  // Get user details
  Future<BackendResponse> getUserDetails() async {
    return await handleRequest(
      request: _dio.get('/auth/me'),
      titleOfRequest: 'getting user details',
    );
  }
  //add fcm token

  Future<BackendResponse> addFcmToken({required String fcmToken}) async {
    return await handleRequest(
      request: _dio.post('/auth/addFcm', data: {'fcmToken': fcmToken}),
      titleOfRequest: 'adding fcm token',
    );
  }

  //remove fcm token
  Future<BackendResponse> removeFcmToken({required String fcmToken}) async {
    return await handleRequest(
      request: _dio.post('/auth/removefcm', data: {'fcmToken': fcmToken}),
      titleOfRequest: 'removing fcm token',
    );
  }

// Post image method
  Future<BackendResponse> postImage({required File image}) async {
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

    return await handleRequest(
      request: _dio.post('/image/details', data: formData),
      titleOfRequest: 'posting image',
    );
  }

  //get image
  Future<BackendResponse> getImage({required String imageUrl}) async {
    return await handleRequest(
      request: _dio.get('/image/details', queryParameters: {'url': imageUrl}),
      titleOfRequest: 'getting image',
    );
  }

  //delete image
  Future<BackendResponse> deleteImage({required String imageUrl}) async {
    return await handleRequest(
      request: _dio.put(
        '/image/details',
        queryParameters: {'url': imageUrl},
      ),
      titleOfRequest: 'deleting image',
    );
  }

  //create an organization control

  Future<BackendResponse> createOrganization(
      {required NewOrganization newOrg}) async {
    return await handleRequest(
      request: _dio.post('/org', data: newOrg.toJson()),
      titleOfRequest: 'creating organization',
    );
  }

  //request for organization verification

  Future<BackendResponse> requestOrgVerification(
      {required String orgId}) async {
    return await handleRequest(
      request: _dio.put('/org/requestverification/$orgId'),
      titleOfRequest: 'requesting organization verification',
    );
  }

  //get organization by id

  Future<BackendResponse> getOrganizationById({required String orgId}) async {
    return await handleRequest(
      request: _dio.get('/org/$orgId'),
      titleOfRequest: 'getting organization by id',
    );
  }

  //update org
  Future<BackendResponse> updateOrg(
      {required NewOrganization organization}) async {
    return await handleRequest(
      request: _dio.put('/org', data: organization.toJson()),
      titleOfRequest: 'updating organization',
    );
  }

  //get organization
  Future<BackendResponse> getOrganization() async {
    return await handleRequest(
      request: _dio.get('/org/byUser'),
      titleOfRequest: 'get organization by uid',
    );
  }

  //update organization
  Future<BackendResponse> updateOrganization(
      {required NewOrganization organization}) async {
    return await handleRequest(
      request: _dio.put('/org', data: organization.toJson()),
      titleOfRequest: 'updating organization',
    );
  }

  //delete organization
  Future<BackendResponse> deleteOrganization() async {
    return await handleRequest(
      request: _dio.put('/org/deleteOrg'),
      titleOfRequest: 'deleting organization',
    );
  }

  // get all services name
  Future<BackendResponse> getAllServiceNames() async {
    return await handleRequest(
      request: _dio.get('/service/serviceName'),
      titleOfRequest: 'getting all service',
    );
  }
  // add service

  Future<BackendResponse> addService({required NewServiceModel service}) async {
    return await handleRequest(
      request: _dio.post(
        '/service/details',
        data: service.toJson(),
      ),
      titleOfRequest: 'adding organization service',
    );
  }

  //request for service verification
  Future<BackendResponse> requestServiceVerification(
      {required String serviceId}) async {
    return await handleRequest(
      request: _dio.put('/service/requestverification/$serviceId'),
      titleOfRequest: 'requesting service verification',
    );
  }

  //get all services
  Future<BackendResponse> getAllServices(
      {required String orgId, required ListingSchema listingSchema}) async {
    return await handleRequest(
      request: _dio.get(
        '/service/org/$orgId',
        queryParameters: listingSchema.toJson(),
      ),
      titleOfRequest: 'getting all services',
    );
  }

  //get all bookings
  Future<BackendResponse> getAllBookings({
    required ListingSchema listingSchema,
  }) async {
    return await handleRequest(
      request: _dio.get(
        '/booking/',
        queryParameters: listingSchema.toJson(),
      ),
      titleOfRequest: 'getting all bookings',
    );
  }

  //change staus of booking

  Future<BackendResponse> changeBookingStatus(
      {required String bid,
      required String bookingStatus,
      String? rejectionMessage}) async {
    return handleRequest(
      request: _dio.put('/booking/changestatus/$bid', data: {
        'bookingstatus': bookingStatus,
        'rejectionMessage': rejectionMessage,
      }),
      titleOfRequest: 'changing booking status',
    );
  }

//get all orders

  Future<BackendResponse> getAllOrders(
      {required ListingSchema listingSchema}) async {
    return await handleRequest(
      request: _dio.get(
        '/order/',
        queryParameters: listingSchema.toJson(),
      ),
      titleOfRequest: 'getting all orders',
    );
  }

  //get all requested orders
  Future<BackendResponse> getAllRequestedOrders(
      {required ListingSchema listingSchema}) async {
    return await handleRequest(
      request: _dio.get(
        '/order/requestedOrders',
        queryParameters: listingSchema.toJson(),
      ),
      titleOfRequest: 'getting all requested orders',
    );
  }

//get order by id
  Future<BackendResponse> getOrderById({required String oid}) async {
    return await handleRequest(
      request: _dio.get('/order/$oid'),
      titleOfRequest: 'getting order by id',
    );
  }

  //change order status
  Future<BackendResponse> acceptOrder({required String oid}) async {
    return handleRequest(
      request: _dio.put(
        '/order/accept/$oid',
      ),
      titleOfRequest: 'changing order status',
    );
  }

  //complete order
  Future<BackendResponse> completeOrder({required String oid}) async {
    return handleRequest(
      request: _dio.put(
        '/order/complete/$oid',
      ),
      titleOfRequest: 'completing order',
    );
  }

  //fetch the reviews for organization
  Future<BackendResponse> getAllReviewsAndRatingsForOrganization(
      {required ListingSchema schema}) async {
    debugPrint('listing schema: ${schema.toJson()}');
    return handleRequest(
      request: _dio.get(
        '/review/org',
        queryParameters: schema.toJson(),
      ),
      titleOfRequest: 'getting all reviews and ratings for organization',
    );
  }

  //data for the organization

  Future<BackendResponse> getOrganizationData() async {
    return handleRequest(
      request: _dio.get('/auth/data-org'),
      titleOfRequest: 'getting organization data',
    );
  }
}
