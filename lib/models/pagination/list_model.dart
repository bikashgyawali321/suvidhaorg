import 'package:json_annotation/json_annotation.dart';

part 'list_model.g.dart';

@JsonSerializable()
class ListingSchema {
  @JsonKey(name: 'page')
  num page;

  @JsonKey(name: 'limit')
  num limit;

  @JsonKey(name: 'status', includeIfNull: false)
  String? status;
  @JsonKey(
    name: 'orgs',
    includeIfNull: false,
  )
  final String? orgs;
  ListingSchema({
    required this.page,
    required this.limit,
    this.status,
    this.orgs,
  });

  factory ListingSchema.fromJson(Map<String, dynamic> json) =>
      _$ListingSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$ListingSchemaToJson(this);
}
