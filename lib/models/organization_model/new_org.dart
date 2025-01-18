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

  String contactPerson;
  String contactNumber;
  String panNo;

  @JsonKey(includeIfNull: false)
  String? message;

  // Since citzImg is optional in Joi schema, it can be null or omitted
  @JsonKey(includeIfNull: false)
  String? citzImg;

  // orgImg and panImg are required as per the Joi schema
  String orgImg;
  String panImg;

  NewOrganization({
    required this.nameOrg,
    required this.intro,
    required this.address,
    required this.longLat,
    required this.contactPerson,
    required this.contactNumber,
    required this.panNo,
    this.message,
    this.citzImg,
    required this.orgImg,
    required this.panImg,
  });

  // fromJson
  factory NewOrganization.fromJson(Map<String, dynamic> json) =>
      _$NewOrganizationFromJson(json);

  // toJson
  Map<String, dynamic> toJson() => _$NewOrganizationToJson(this);
}

LongitudeLatitudeModel _longLatFromJson(Map<String, dynamic> json) {
  return LongitudeLatitudeModel.fromJson(json);
}

Map<String, dynamic> _longLatToJson(LongitudeLatitudeModel longLat) {
  return longLat.toJson();
}
