import 'package:json_annotation/json_annotation.dart';

part 'service_name.g.dart';

@JsonSerializable()
class ServiceNameModel {
  @JsonKey(name: '_id')
  String? id;
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'servicecode')
  final String serviceCode;

  ServiceNameModel({
    required this.name,
    required this.serviceCode,
    this.id,
  });

  factory ServiceNameModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceNameModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceNameModelToJson(this);
}
