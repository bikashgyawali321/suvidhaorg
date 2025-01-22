import 'package:json_annotation/json_annotation.dart';

part 'new_service.g.dart';

@JsonSerializable()
class NewServiceModel {
  @JsonKey(name: 'service')
  String service;

  @JsonKey(name: 'serviceprovidername')
  String serviceProviderName;

  @JsonKey(name: 'serviceprovideremail')
  String serviceProviderEmail;

  @JsonKey(name: 'serviceproviderphone')
  String serviceProviderPhone;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'price')
  double price;

  @JsonKey(name: 'img')
  List<String>? img;

  NewServiceModel({
    required this.service,
    required this.serviceProviderName,
    required this.serviceProviderEmail,
    required this.serviceProviderPhone,
    required this.description,
    required this.price,
    this.img,
  });

  factory NewServiceModel.fromJson(Map<String, dynamic> json) =>
      _$NewServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewServiceModelToJson(this);
}
