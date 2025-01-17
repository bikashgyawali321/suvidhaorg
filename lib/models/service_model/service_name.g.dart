// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceName _$ServiceNameFromJson(Map<String, dynamic> json) => ServiceName(
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
    )..id = json['_id'] as String?;

Map<String, dynamic> _$ServiceNameToJson(ServiceName instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'isActive': instance.isActive,
    };
