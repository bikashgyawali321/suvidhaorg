// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['_id'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      password: json['password'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String?,
      isBlocked: json['isBlocked'] as bool?,
      isEmailVerified: json['isEmailVerified'] as bool?,
      otp: json['otp'] as String?,
      otpExpires: json['otpExpires'] == null
          ? null
          : DateTime.parse(json['otpExpires'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      fcmTokens: (json['fcmTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'password': instance.password,
      'phoneNumber': instance.phoneNumber,
      'role': instance.role,
      'isBlocked': instance.isBlocked,
      'isEmailVerified': instance.isEmailVerified,
      'otp': instance.otp,
      'otpExpires': instance.otpExpires?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'fcmTokens': instance.fcmTokens,
    };
