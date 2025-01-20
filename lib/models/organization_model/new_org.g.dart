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
      contactPerson: json['contactPerson'] as String,
      contactNumber: json['contactNumber'] as String,
      panNo: json['panNo'] as String,
      message: json['message'] as String?,
      citzImg:
          (json['citzImg'] as List<dynamic>?)?.map((e) => e as String).toList(),
      orgImg:
          (json['orgImg'] as List<dynamic>).map((e) => e as String).toList(),
      panImg:
          (json['panImg'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$NewOrganizationToJson(NewOrganization instance) =>
    <String, dynamic>{
      'nameOrg': instance.nameOrg,
      'intro': instance.intro,
      'address': instance.address,
      'longLat': _longLatToJson(instance.longLat),
      'contactPerson': instance.contactPerson,
      'contactNumber': instance.contactNumber,
      'panNo': instance.panNo,
      if (instance.message case final value?) 'message': value,
      if (instance.citzImg case final value?) 'citzImg': value,
      'orgImg': instance.orgImg,
      'panImg': instance.panImg,
    };
