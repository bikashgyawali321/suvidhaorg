import 'package:json_annotation/json_annotation.dart';
import 'coordinates.dart';

part 'org.g.dart';

@JsonSerializable()
class OrganizationModel {
  @JsonKey(name: '_id')
  String id;
  String nameOrg;
  String intro;
  String slug;
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
  List<String> citzImg;
  List<String> orgImg;
  List<String> panImg;
  DateTime createdAt;
  DateTime updatedAt;
  String user;

  OrganizationModel({
    required this.id,
    required this.nameOrg,
    required this.intro,
    required this.slug,
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
    required this.citzImg,
    required this.orgImg,
    required this.panImg,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  // fromJson
  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);

  // toJson
  Map<String, dynamic> toJson() => _$OrganizationModelToJson(this);
}

LongitudeLatitudeModel _longLatFromJson(Map<String, dynamic> json) {
  return LongitudeLatitudeModel.fromJson(json);
}

Map<String, dynamic> _longLatToJson(LongitudeLatitudeModel longLat) {
  return longLat.toJson();
}
