// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewServiceModel _$NewServiceModelFromJson(Map<String, dynamic> json) =>
    NewServiceModel(
      service: json['service'] as String,
      serviceProviderName: json['serviceprovidername'] as String,
      serviceProviderEmail: json['serviceprovideremail'] as String,
      serviceProviderPhone: json['serviceproviderphone'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      status: json['status'] as String? ?? 'Rejected',
      img: (json['img'] as List<dynamic>?)?.map((e) => e as String).toList(),
      totalRatedBy: (json['totalratedby'] as num?)?.toInt(),
      totalRating: (json['totalrating'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NewServiceModelToJson(NewServiceModel instance) =>
    <String, dynamic>{
      'service': instance.service,
      'serviceprovidername': instance.serviceProviderName,
      'serviceprovideremail': instance.serviceProviderEmail,
      'serviceproviderphone': instance.serviceProviderPhone,
      'description': instance.description,
      'price': instance.price,
      'isActive': instance.isActive,
      'status': instance.status,
      'img': instance.img,
      'totalratedby': instance.totalRatedBy,
      'totalrating': instance.totalRating,
      'rating': instance.rating,
    };
