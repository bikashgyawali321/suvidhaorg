// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) => ServiceModel(
      id: json['_id'] as String,
      orgName: json['nameOrg'] as String?,
      service: json['serviceName'] as String,
      serviceProviderName: json['serviceprovidername'] as String,
      serviceProviderEmail: json['serviceprovideremail'] as String,
      serviceProviderPhone: json['serviceproviderphone'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      isBlocked: json['isBlocked'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      status: json['status'] as String? ?? 'Not Requested',
      message: json['message'] as String?,
      img: (json['img'] as List<dynamic>).map((e) => e as String).toList(),
      totalRatedBy: (json['totalRatedBy'] as num?)?.toInt(),
      totalRating: (json['totalRating'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      orgId: json['org'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'org': instance.orgId,
      'nameOrg': instance.orgName,
      'serviceName': instance.service,
      'serviceprovidername': instance.serviceProviderName,
      'serviceprovideremail': instance.serviceProviderEmail,
      'serviceproviderphone': instance.serviceProviderPhone,
      'description': instance.description,
      'price': instance.price,
      'isBlocked': instance.isBlocked,
      'isActive': instance.isActive,
      'status': instance.status,
      'message': instance.message,
      'img': instance.img,
      'totalRatedBy': instance.totalRatedBy,
      'totalRating': instance.totalRating,
      'rating': instance.rating,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
