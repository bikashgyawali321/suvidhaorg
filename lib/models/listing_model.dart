import 'package:json_annotation/json_annotation.dart';

part 'listing_model.g.dart';

@JsonSerializable()
class ListingModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'orgs')
  final String? orgs;

  @JsonKey(name: 'services')
  final String? services;

  @JsonKey(name: 'page')
  final int? page;

  @JsonKey(name: 'limit')
  final int? limit;

  @JsonKey(name: 'search')
  final String? search;

  @JsonKey(name: 'sort')
  final String? sort;

  @JsonKey(name: 'dir')
  final String? dir;

  @JsonKey(name: 'isActive')
  final bool? isActive;

  @JsonKey(name: 'isBlocked')
  final bool? isBlocked;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'slug')
  final String? slug;

  @JsonKey(name: 'minRating')
  final double? minRating;

  @JsonKey(name: 'maxRating')
  final double? maxRating;

  @JsonKey(name: 'minPrice')
  final double? minPrice;

  @JsonKey(name: 'maxPrice')
  final double? maxPrice;

  ListingModel({
    this.id,
    this.orgs,
    this.services,
    this.page,
    this.limit,
    this.search,
    this.sort,
    this.dir,
    this.isActive,
    this.isBlocked,
    this.status,
    this.type,
    this.slug,
    this.minRating,
    this.maxRating,
    this.minPrice,
    this.maxPrice,
  });

  // Factory method to generate an instance from JSON
  factory ListingModel.fromJson(Map<String, dynamic> json) => _$ListingModelFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$ListingModelToJson(this);
}
