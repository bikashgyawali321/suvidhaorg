import 'package:json_annotation/json_annotation.dart';
import 'coordinates.dart';

part 'new_org.g.dart';

@JsonSerializable()
class NewOrganization {
  String nameOrg;
  String intro;
  String address;

  @JsonKey(fromJson: _longLatFromJson, toJson: _longLatToJson)
  LongitudeLatitudeModel longLat;
  
  bool isBlocked;
  bool isActive;
  String? status;
  String contactPerson;
  String contactNumber;
  String panNo;
  String? message;
  num? ratedBy;
  num? rating;
  num? totalRating;
  List<String> service;
  String citzImg;
  String orgImg;
  String panImg;

  NewOrganization({
    required this.nameOrg,
    required this.intro,
    required this.address,
    required this.longLat,
    required this.isBlocked,
    required this.isActive,
    this.status,
    required this.contactPerson,
    required this.contactNumber,
    required this.panNo,
    this.message,
    this.ratedBy,
    this.rating,
    this.totalRating,
    required this.service,
    required this.citzImg,
    required this.orgImg,
    required this.panImg,
  });

  // fromJson
  factory NewOrganization.fromJson(Map<String, dynamic> json) => _$NewOrganizationFromJson(json);

  // toJson
  Map<String, dynamic> toJson() => _$NewOrganizationToJson(this);
}

LongitudeLatitudeModel _longLatFromJson(Map<String, dynamic> json) {
  return LongitudeLatitudeModel.fromJson(json);
}

Map<String, dynamic> _longLatToJson(LongitudeLatitudeModel longLat) {
  return longLat.toJson();
}
