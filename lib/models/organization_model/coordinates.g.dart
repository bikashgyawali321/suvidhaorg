// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LongitudeLatitudeModel _$LongitudeLatitudeModelFromJson(
        Map<String, dynamic> json) =>
    LongitudeLatitudeModel(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$LongitudeLatitudeModelToJson(
        LongitudeLatitudeModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
