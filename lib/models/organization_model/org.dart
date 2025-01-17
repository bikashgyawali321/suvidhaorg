import 'package:json_annotation/json_annotation.dart';
import 'package:suvidhaorg/models/auth_models/user_model.dart';
import 'longlat.dart';

part 'org.g.dart';

@JsonSerializable()
class Organization {
  @JsonKey(name: '_id')
  String id;
  String nameOrg;
  String intro;
  String slug;
  String address;

  @JsonKey(fromJson: _longLatFromJson, toJson: _longLatToJson)
  LongLat longLat;

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
  UserModel user; 

  Organization({
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
  factory Organization.fromJson(Map<String, dynamic> json) => _$OrganizationFromJson(json);

  // toJson
  Map<String, dynamic> toJson() => _$OrganizationToJson(this);
}

// Helper functions for longLat serialization
LongLat _longLatFromJson(Map<String, dynamic> json) {
  return LongLat.fromJson(json);
}

Map<String, dynamic> _longLatToJson(LongLat longLat) {
  return longLat.toJson();
}
