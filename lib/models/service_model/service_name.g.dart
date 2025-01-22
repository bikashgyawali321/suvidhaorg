// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceNameModel _$ServiceNameModelFromJson(Map<String, dynamic> json) =>
    ServiceNameModel(
      name: json['name'] as String,
      serviceCode: json['servicecode'] as String,
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$ServiceNameModelToJson(ServiceNameModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'servicecode': instance.serviceCode,
    };
