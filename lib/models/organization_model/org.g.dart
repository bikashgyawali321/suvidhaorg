// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'org.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organization _$OrganizationFromJson(Map<String, dynamic> json) => Organization(
      id: json['_id'] as String,
      nameOrg: json['nameOrg'] as String,
      intro: json['intro'] as String,
      slug: json['slug'] as String,
      address: json['address'] as String,
      longLat: _longLatFromJson(json['longLat'] as Map<String, dynamic>),
      isBlocked: json['isBlocked'] as bool,
      isActive: json['isActive'] as bool,
      status: json['status'] as String?,
      contactPerson: json['contactPerson'] as String,
      contactNumber: json['contactNumber'] as String,
      panNo: json['panNo'] as String,
      message: json['message'] as String?,
      ratedBy: json['ratedBy'] as num?,
      rating: json['rating'] as num?,
      totalRating: json['totalRating'] as num?,
      citzImg:
          (json['citzImg'] as List<dynamic>).map((e) => e as String).toList(),
      orgImg:
          (json['orgImg'] as List<dynamic>).map((e) => e as String).toList(),
      panImg:
          (json['panImg'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrganizationToJson(Organization instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'nameOrg': instance.nameOrg,
      'intro': instance.intro,
      'slug': instance.slug,
      'address': instance.address,
      'longLat': _longLatToJson(instance.longLat),
      'isBlocked': instance.isBlocked,
      'isActive': instance.isActive,
      'status': instance.status,
      'contactPerson': instance.contactPerson,
      'contactNumber': instance.contactNumber,
      'panNo': instance.panNo,
      'message': instance.message,
      'ratedBy': instance.ratedBy,
      'rating': instance.rating,
      'totalRating': instance.totalRating,
      'citzImg': instance.citzImg,
      'orgImg': instance.orgImg,
      'panImg': instance.panImg,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'user': instance.user,
    };
