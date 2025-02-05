// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewServiceModel _$NewServiceModelFromJson(Map<String, dynamic> json) =>
    NewServiceModel(
      serviceName: json['serviceName'] as String,
      serviceProviderName: json['serviceprovidername'] as String,
      serviceProviderEmail: json['serviceprovideremail'] as String,
      serviceProviderPhone: json['serviceproviderphone'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      img: (json['img'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$NewServiceModelToJson(NewServiceModel instance) =>
    <String, dynamic>{
      'serviceName': instance.serviceName,
      'serviceprovidername': instance.serviceProviderName,
      'serviceprovideremail': instance.serviceProviderEmail,
      'serviceproviderphone': instance.serviceProviderPhone,
      'description': instance.description,
      'price': instance.price,
      'img': instance.img,
    };
