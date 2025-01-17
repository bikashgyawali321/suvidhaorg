// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_org.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewOrganization _$NewOrganizationFromJson(Map<String, dynamic> json) =>
    NewOrganization(
      nameOrg: json['nameOrg'] as String,
      intro: json['intro'] as String,
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
      service:
          (json['service'] as List<dynamic>).map((e) => e as String).toList(),
      citzImg: json['citzImg'] as String,
      orgImg: json['orgImg'] as String,
      panImg: json['panImg'] as String,
    );

Map<String, dynamic> _$NewOrganizationToJson(NewOrganization instance) =>
    <String, dynamic>{
      'nameOrg': instance.nameOrg,
      'intro': instance.intro,
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
      'service': instance.service,
      'citzImg': instance.citzImg,
      'orgImg': instance.orgImg,
      'panImg': instance.panImg,
    };
