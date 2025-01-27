// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingSchema _$ListingSchemaFromJson(Map<String, dynamic> json) =>
    ListingSchema(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$ListingSchemaToJson(ListingSchema instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
    };
