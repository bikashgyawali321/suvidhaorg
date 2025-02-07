import 'package:json_annotation/json_annotation.dart';

part 'organization_data_response.g.dart';

@JsonSerializable()
class OrganizationDataResponse {
  @JsonKey(name: 'service')
  final num totalServices;
  @JsonKey(name: 'bookingAll')
  final num totalBookings;
  @JsonKey(name: 'bookingPending')
  final num pendingBookings;
  @JsonKey(name: 'bookingAccepted')
  final num acceptedBookings;
  @JsonKey(name: 'bookingCompleted')
  final num completedBookings;
  @JsonKey(name: 'orderAll')
  final num totalOrders;

  @JsonKey(name: 'orderAccepted')
  final num acceptedOrders;
  @JsonKey(name: 'orderCompleted')
  final num completedOrders;

  @JsonKey(name: 'bookingRejected')
  final num rejectedBookings;
  @JsonKey(name: "pendingOrders")
  final num pendingOrders;

  OrganizationDataResponse({
    required this.totalServices,
    required this.totalBookings,
    required this.pendingBookings,
    required this.acceptedBookings,
    required this.completedBookings,
    required this.totalOrders,
    required this.acceptedOrders,
    required this.completedOrders,
    required this.rejectedBookings,
    required this.pendingOrders,
  });

  factory OrganizationDataResponse.fromJson(Map<String, dynamic> json) =>
      _$OrganizationDataResponseFromJson(json);
}
