// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_array_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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

DocsUserForOrder _$DocsUserForOrderFromJson(Map<String, dynamic> json) =>
    DocsUserForOrder(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profilePic: json['profilePic'] as String?,
    );

Map<String, dynamic> _$DocsUserForOrderToJson(DocsUserForOrder instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'profilePic': instance.profilePic,
    };

DocsServiceNameForOrder _$DocsServiceNameForOrderFromJson(
        Map<String, dynamic> json) =>
    DocsServiceNameForOrder(
      id: json['_id'] as String,
      name: json['name'] as String,
      serviceCode: json['servicecode'] as String,
    );

Map<String, dynamic> _$DocsServiceNameForOrderToJson(
        DocsServiceNameForOrder instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'servicecode': instance.serviceCode,
    };

DocsServiceForOrder _$DocsServiceForOrderFromJson(Map<String, dynamic> json) =>
    DocsServiceForOrder(
      id: json['_id'] as String,
      serviceProviderName: json['serviceprovidername'] as String,
      serviceProviderEmail: json['serviceprovideremail'] as String,
      serviceProviderPhone: json['serviceproviderphone'] as String,
      img: (json['img'] as List<dynamic>).map((e) => e as String).toList(),
      rating: (json['rating'] as num).toDouble(),
    );

Map<String, dynamic> _$DocsServiceForOrderToJson(
        DocsServiceForOrder instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'serviceprovidername': instance.serviceProviderName,
      'serviceprovideremail': instance.serviceProviderEmail,
      'serviceproviderphone': instance.serviceProviderPhone,
      'img': instance.img,
      'rating': instance.rating,
    };

DocsOrder _$DocsOrderFromJson(Map<String, dynamic> json) => DocsOrder(
      id: json['_id'] as String,
      serviceName: DocsServiceNameForOrder.fromJson(
          json['servicenames'] as Map<String, dynamic>),
      serviceNameId: json['serviceName'] as String,
      service: json['service'] == null
          ? null
          : DocsServiceForOrder.fromJson(
              json['service'] as Map<String, dynamic>),
      user: DocsUserForOrder.fromJson(json['user'] as Map<String, dynamic>),
      status: json['status'] as String,
      location: json['location'] as String,
      price: json['price'] as num?,
      isActive: json['isActive'] as bool,
      isBlocked: json['isBlocked'] as bool,
      longLat: LongitudeLatitudeModel.fromJson(
          json['longLat'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DocsOrderToJson(DocsOrder instance) => <String, dynamic>{
      '_id': instance.id,
      if (instance.service?.toJson() case final value?) 'service': value,
      'serviceName': instance.serviceNameId,
      'servicenames': instance.serviceName.toJson(),
      'user': instance.user.toJson(),
      'status': instance.status,
      'location': instance.location,
      if (instance.price case final value?) 'price': value,
      'isActive': instance.isActive,
      'isBlocked': instance.isBlocked,
      'longLat': instance.longLat.toJson(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

OrderArrayResponse _$OrderArrayResponseFromJson(Map<String, dynamic> json) =>
    OrderArrayResponse(
      docs: OrderArrayResponse._docsFromJson(json['docs'] as List),
      pagination:
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderArrayResponseToJson(OrderArrayResponse instance) =>
    <String, dynamic>{
      'docs': instance.docs,
      'pagination': instance.pagination,
    };
