import 'package:json_annotation/json_annotation.dart';
import 'package:suvidhaorg/models/organization_model/coordinates.dart';

part 'order_array_response.g.dart';

@JsonSerializable()
class Pagination {
  final int total;
  final int page;
  final int limit;
  @JsonKey(defaultValue: false)
  final bool previousPage;
  @JsonKey(defaultValue: false)
  final bool nextPage;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.previousPage,
    required this.nextPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}

@JsonSerializable()
class DocsUserForOrder {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'phoneNumber')
  final String phoneNumber;
  @JsonKey(
    name: 'profilePic',
    defaultValue: null,
  )
  final String? profilePic;

  DocsUserForOrder({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profilePic,
  });

  factory DocsUserForOrder.fromJson(Map<String, dynamic> json) =>
      _$DocsUserForOrderFromJson(json);

  Map<String, dynamic> toJson() => _$DocsUserForOrderToJson(this);
}

@JsonSerializable()
class DocsServiceNameForOrder {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'servicecode')
  final String serviceCode;

  DocsServiceNameForOrder({
    required this.id,
    required this.name,
    required this.serviceCode,
  });

  factory DocsServiceNameForOrder.fromJson(Map<String, dynamic> json) =>
      _$DocsServiceNameForOrderFromJson(json);

  Map<String, dynamic> toJson() => _$DocsServiceNameForOrderToJson(this);
}

@JsonSerializable()
class DocsServiceForOrder {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'serviceprovidername')
  final String serviceProviderName;
  @JsonKey(name: 'serviceprovideremail')
  final String serviceProviderEmail;
  @JsonKey(name: 'serviceproviderphone')
  final String serviceProviderPhone;
  @JsonKey(name: 'img')
  final List<String> img;
  @JsonKey(name: 'rating')
  final double rating;

  DocsServiceForOrder({
    required this.id,
    required this.serviceProviderName,
    required this.serviceProviderEmail,
    required this.serviceProviderPhone,
    required this.img,
    required this.rating,
  });

  factory DocsServiceForOrder.fromJson(Map<String, dynamic> json) =>
      _$DocsServiceForOrderFromJson(json);

  Map<String, dynamic> toJson() => _$DocsServiceForOrderToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class DocsOrder {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'service', defaultValue: null)
  final DocsServiceForOrder? service;

  @JsonKey(name: "serviceName")
  final String serviceNameId;

  @JsonKey(name: 'servicenames')
  final DocsServiceNameForOrder serviceName;

  @JsonKey(name: 'user')
  final DocsUserForOrder user;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'location')
  final String location;

  @JsonKey(name: 'price')
  final num? price;

  @JsonKey(name: 'isActive')
  final bool isActive;

  @JsonKey(name: 'isBlocked')
  final bool isBlocked;

  @JsonKey(name: 'longLat')
  final LongitudeLatitudeModel longLat;

  final DateTime createdAt;
  final DateTime updatedAt;

  DocsOrder({
    required this.id,
    required this.serviceName,
    required this.serviceNameId,
    this.service,
    required this.user,
    required this.status,
    required this.location,
    this.price,
    required this.isActive,
    required this.isBlocked,
    required this.longLat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocsOrder.fromJson(Map<String, dynamic> json) =>
      _$DocsOrderFromJson(json);

  Map<String, dynamic> toJson() => _$DocsOrderToJson(this);
}

@JsonSerializable()
class OrderArrayResponse {
  @JsonKey(name: 'docs', fromJson: _docsFromJson)
  final List<DocsOrder> docs;
  @JsonKey(name: 'pagination', fromJson: Pagination.fromJson)
  final Pagination pagination;

  OrderArrayResponse({
    required this.docs,
    required this.pagination,
  });

  factory OrderArrayResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderArrayResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderArrayResponseToJson(this);

  static List<DocsOrder> _docsFromJson(List<dynamic> json) =>
      json.map((e) => DocsOrder.fromJson(e as Map<String, dynamic>)).toList();
}
