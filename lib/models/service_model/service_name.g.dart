// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceNameModel _$ServiceNameModelFromJson(Map<String, dynamic> json) =>
    ServiceNameModel(
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
      serviceCode: json['servicecode'] as String,
      id: json['_id'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ServiceNameModelToJson(ServiceNameModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'isActive': instance.isActive,
      'servicecode': instance.serviceCode,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
