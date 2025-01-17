import 'package:json_annotation/json_annotation.dart';

part 'image_model.g.dart';

@JsonSerializable()
class ImageModel {
  @JsonKey(name: '_id') 
  String? id;

  @JsonKey(name: 'url') 
  String? url;

  @JsonKey(name: 'publicId', includeIfNull: false) 
  String? publicId;

  @JsonKey(name: 'isActive') 
  bool? isActive;
  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'createdAt') 
  DateTime? createdAt;

  @JsonKey(name: 'updatedAt') 
  DateTime? updatedAt;

  ImageModel({
    this.id,
    this.url,
    this.publicId,
    this.isActive,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageModelToJson(this);
}
