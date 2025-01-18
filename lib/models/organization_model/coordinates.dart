import 'package:json_annotation/json_annotation.dart';

part 'coordinates.g.dart'; 

@JsonSerializable()
class LongitudeLatitudeModel {
  String type;
  List<double> coordinates;

  LongitudeLatitudeModel({required this.type, required this.coordinates});

  factory LongitudeLatitudeModel.fromJson(Map<String, dynamic> json) => _$LongitudeLatitudeModelFromJson(json);
  Map<String, dynamic> toJson() => _$LongitudeLatitudeModelToJson(this);
}
