// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      service: json['service'] as String,
      serviceprovidername: json['serviceprovidername'] as String,
      serviceprovideremail: json['serviceprovideremail'] as String,
      serviceproviderphone: json['serviceproviderphone'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      status: json['status'] as String? ?? "Rejected",
      img: (json['img'] as List<dynamic>?)?.map((e) => e as String).toList(),
      totalratedby: (json['totalratedby'] as num?)?.toInt(),
      totalrating: (json['totalrating'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'service': instance.service,
      'serviceprovidername': instance.serviceprovidername,
      'serviceprovideremail': instance.serviceprovideremail,
      'serviceproviderphone': instance.serviceproviderphone,
      'description': instance.description,
      'price': instance.price,
      'isActive': instance.isActive,
      'status': instance.status,
      'img': instance.img,
      'totalratedby': instance.totalratedby,
      'totalrating': instance.totalrating,
      'rating': instance.rating,
    };
