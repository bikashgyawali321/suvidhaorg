// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingModel _$ListingModelFromJson(Map<String, dynamic> json) => ListingModel(
      id: json['id'] as String?,
      orgs: json['orgs'] as String?,
      services: json['services'] as String?,
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      search: json['search'] as String?,
      sort: json['sort'] as String?,
      dir: json['dir'] as String?,
      isActive: json['isActive'] as bool?,
      isBlocked: json['isBlocked'] as bool?,
      status: json['status'] as String?,
      type: json['type'] as String?,
      slug: json['slug'] as String?,
      minRating: (json['minRating'] as num?)?.toDouble(),
      maxRating: (json['maxRating'] as num?)?.toDouble(),
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ListingModelToJson(ListingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgs': instance.orgs,
      'services': instance.services,
      'page': instance.page,
      'limit': instance.limit,
      'search': instance.search,
      'sort': instance.sort,
      'dir': instance.dir,
      'isActive': instance.isActive,
      'isBlocked': instance.isBlocked,
      'status': instance.status,
      'type': instance.type,
      'slug': instance.slug,
      'minRating': instance.minRating,
      'maxRating': instance.maxRating,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
    };
