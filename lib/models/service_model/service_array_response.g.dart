// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_array_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceArrayResponse _$ServiceArrayResponseFromJson(
        Map<String, dynamic> json) =>
    ServiceArrayResponse(
      pagination:
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      docs: ServiceArrayResponse._docsFromJson(json['docs'] as List),
    );

Map<String, dynamic> _$ServiceArrayResponseToJson(
        ServiceArrayResponse instance) =>
    <String, dynamic>{
      'pagination': instance.pagination,
      'docs': ServiceArrayResponse._docsToJson(instance.docs),
    };

DocsOrganization _$DocsOrganizationFromJson(Map<String, dynamic> json) =>
    DocsOrganization(
      id: json['_id'] as String,
      organizationName: json['nameOrg'] as String,
    );

Map<String, dynamic> _$DocsOrganizationToJson(DocsOrganization instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'nameOrg': instance.organizationName,
    };

DocsServiceName _$DocsServiceNameFromJson(Map<String, dynamic> json) =>
    DocsServiceName(
      id: json['_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$DocsServiceNameToJson(DocsServiceName instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
    };

DocsService _$DocsServiceFromJson(Map<String, dynamic> json) => DocsService(
      org: DocsOrganization.fromJson(json['org'] as Map<String, dynamic>),
      serviceName:
          DocsServiceName.fromJson(json['service'] as Map<String, dynamic>),
      id: json['_id'] as String,
      serviceProviderName: json['serviceprovidername'] as String,
      serviceProviderEmail: json['serviceprovideremail'] as String,
      serviceProviderPhone: json['serviceproviderphone'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      status: json['status'] as String,
      message: json['message'] as String?,
      img: (json['img'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DocsServiceToJson(DocsService instance) =>
    <String, dynamic>{
      'org': instance.org,
      'service': instance.serviceName,
      '_id': instance.id,
      'serviceprovidername': instance.serviceProviderName,
      'serviceprovideremail': instance.serviceProviderEmail,
      'serviceproviderphone': instance.serviceProviderPhone,
      'description': instance.description,
      'price': instance.price,
      'isActive': instance.isActive,
      'status': instance.status,
      'message': instance.message,
      'img': instance.img,
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      previousPage: json['previousPage'] as bool? ?? false,
      nextPage: json['nextPage'] as bool? ?? false,
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'previousPage': instance.previousPage,
      'nextPage': instance.nextPage,
    };
