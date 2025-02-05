import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart';

@JsonSerializable()
class ServiceModel {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: "org", defaultValue: null)
  final String? orgId;
  @JsonKey(name: 'nameOrg', defaultValue: null)
  final String? orgName;

  @JsonKey(name: 'serviceName')
  final String service;

  @JsonKey(name: 'serviceprovidername')
  final String serviceProviderName;

  @JsonKey(name: 'serviceprovideremail')
  final String serviceProviderEmail;

  @JsonKey(name: 'serviceproviderphone')
  final String serviceProviderPhone;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'price')
  final double price;

  @JsonKey(name: 'isBlocked', defaultValue: false)
  final bool isBlocked;

  @JsonKey(name: 'isActive', defaultValue: true)
  final bool isActive;

  @JsonKey(name: 'status', defaultValue: 'Not Requested')
  final String status;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'img')
  final List<String> img;

  @JsonKey(name: 'totalRatedBy')
  final int? totalRatedBy;

  @JsonKey(name: 'totalRating')
  final double? totalRating;

  @JsonKey(name: 'rating')
  final double? rating;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  ServiceModel({
    required this.id,
    required this.orgName,
    required this.service,
    required this.serviceProviderName,
    required this.serviceProviderEmail,
    required this.serviceProviderPhone,
    required this.description,
    required this.price,
    this.isBlocked = false,
    this.isActive = true,
    this.status = 'Not Requested',
    this.message,
    required this.img,
    this.totalRatedBy,
    this.totalRating,
    this.rating,
    this.orgId,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
}
