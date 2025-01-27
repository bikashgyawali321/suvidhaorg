import 'package:json_annotation/json_annotation.dart';

part 'service_array_response.g.dart';

@JsonSerializable()
class ServiceArrayResponse {
  @JsonKey(name: 'pagination', fromJson: Pagination.fromJson)
  final Pagination pagination;

  @JsonKey(
    name: 'docs',
    fromJson: _docsFromJson,
    toJson: _docsToJson,
  )
  final List<DocsService> docs;

  ServiceArrayResponse({
    required this.pagination,
    required this.docs,
  });

  factory ServiceArrayResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceArrayResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceArrayResponseToJson(this);

  static List<DocsService> _docsFromJson(List<dynamic> json) =>
      json.map((e) => DocsService.fromJson(e as Map<String, dynamic>)).toList();

  static List<Map<String, dynamic>> _docsToJson(List<DocsService> docs) =>
      docs.map((e) => e.toJson()).toList();
}

@JsonSerializable()
class DocsOrganization {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'nameOrg')
  final String organizationName;

  DocsOrganization({
    required this.id,
    required this.organizationName,
  });

  factory DocsOrganization.fromJson(Map<String, dynamic> json) =>
      _$DocsOrganizationFromJson(json);

  Map<String, dynamic> toJson() => _$DocsOrganizationToJson(this);
}

@JsonSerializable()
class DocsServiceName {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'name')
  final String name;

  DocsServiceName({
    required this.id,
    required this.name,
  });

  factory DocsServiceName.fromJson(Map<String, dynamic> json) =>
      _$DocsServiceNameFromJson(json);

  Map<String, dynamic> toJson() => _$DocsServiceNameToJson(this);
}

@JsonSerializable()
class DocsService {
  @JsonKey(name: 'org', fromJson: DocsOrganization.fromJson)
  final DocsOrganization org;
  @JsonKey(name: 'service', fromJson: DocsServiceName.fromJson)
  final DocsServiceName serviceName;
  @JsonKey(name: '_id')
  final String id;
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
  @JsonKey(name: "isActive")
  final bool isActive;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'img')
  final List<String> img;

  DocsService({
    required this.org,
    required this.serviceName,
    required this.id,
    required this.serviceProviderName,
    required this.serviceProviderEmail,
    required this.serviceProviderPhone,
    required this.description,
    required this.price,
    required this.isActive,
    required this.status,
    this.message,
    required this.img,
  });

  factory DocsService.fromJson(Map<String, dynamic> json) =>
      _$DocsServiceFromJson(json);

  Map<String, dynamic> toJson() => _$DocsServiceToJson(this);
}

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
