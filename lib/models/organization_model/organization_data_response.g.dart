// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizationDataResponse _$OrganizationDataResponseFromJson(
        Map<String, dynamic> json) =>
    OrganizationDataResponse(
      totalServices: json['service'] as num,
      totalBookings: json['bookingAll'] as num,
      pendingBookings: json['bookingPending'] as num,
      acceptedBookings: json['bookingAccepted'] as num,
      completedBookings: json['bookingCompleted'] as num,
      totalOrders: json['orderAll'] as num,
      acceptedOrders: json['orderAccepted'] as num,
      completedOrders: json['orderCompleted'] as num,
      rejectedBookings: json['bookingRejected'] as num,
      pendingOrders: json['pendingOrders'] as num,
    );

Map<String, dynamic> _$OrganizationDataResponseToJson(
        OrganizationDataResponse instance) =>
    <String, dynamic>{
      'service': instance.totalServices,
      'bookingAll': instance.totalBookings,
      'bookingPending': instance.pendingBookings,
      'bookingAccepted': instance.acceptedBookings,
      'bookingCompleted': instance.completedBookings,
      'orderAll': instance.totalOrders,
      'orderAccepted': instance.acceptedOrders,
      'orderCompleted': instance.completedOrders,
      'bookingRejected': instance.rejectedBookings,
      'pendingOrders': instance.pendingOrders,
    };
