import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'service_name.g.dart';

@JsonSerializable()
class ServiceNameModel {
  @JsonKey(name: '_id')
  String? id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'isActive')
  final bool isActive;

  @JsonKey(name: 'servicecode')
  final String serviceCode;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  ServiceNameModel({
    required this.name,
    required this.isActive,
    required this.serviceCode,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceNameModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceNameModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceNameModelToJson(this);
}
