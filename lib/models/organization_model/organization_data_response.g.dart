// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizationDataResponse _$OrganizationDataResponseFromJson(
        Map<String, dynamic> json) =>
    OrganizationDataResponse(
      org: json['org'] as num,
      totalOrg: json['service'] as num,
      totalBookings: json['bookingAll'] as num,
      pendingBookings: json['bookingPending'] as num,
      completedBookings: json['bookingCompleted'] as num,
      totalOrders: json['orderAll'] as num,
      acceptedOrders: json['orderAccepted'] as num,
      completedOrders: json['orderCompleted'] as num,
      rejectedOrders: json['orderRejected'] as num,
      rejectedBookings: json['bookingRejected'] as num,
    );

Map<String, dynamic> _$OrganizationDataResponseToJson(
        OrganizationDataResponse instance) =>
    <String, dynamic>{
      'org': instance.org,
      'service': instance.totalOrg,
      'bookingAll': instance.totalBookings,
      'bookingPending': instance.pendingBookings,
      'bookingCompleted': instance.completedBookings,
      'orderAll': instance.totalOrders,
      'orderAccepted': instance.acceptedOrders,
      'orderCompleted': instance.completedOrders,
      'orderRejected': instance.rejectedOrders,
      'bookingRejected': instance.rejectedBookings,
    };
