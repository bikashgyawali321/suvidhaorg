import 'package:json_annotation/json_annotation.dart';

part 'list_model.g.dart';

@JsonSerializable()
class ListingSchema {
  @JsonKey(name: 'page')
  num page;

  @JsonKey(name: 'limit')
  num limit;

  ListingSchema({
    required this.page,
    required this.limit,
  });

  factory ListingSchema.fromJson(Map<String, dynamic> json) =>
      _$ListingSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$ListingSchemaToJson(this);
}
