import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

//array response for booking
@JsonSerializable()
class BookingArrayResponse {
  @JsonKey(name: 'pagination', fromJson: Pagination.fromJson)
  final Pagination pagination;

  @JsonKey(
      name: 'docs', fromJson: _docsBookingsFromJson, toJson: _docsBookingToJson)
  List<DocsBooking> docs;
  BookingArrayResponse({required this.pagination, required this.docs});

  factory BookingArrayResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingArrayResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookingArrayResponseToJson(this);

  static List<DocsBooking> _docsBookingsFromJson(List<dynamic> json) =>
      json.map((e) => DocsBooking.fromJson(e as Map<String, dynamic>)).toList();

  static List<Map<String, dynamic>> _docsBookingToJson(
          List<DocsBooking> docs) =>
      docs.map((e) => e.toJson()).toList();
}

//pagination
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

//booking model for doc response
@JsonSerializable()
class DocsBooking {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'user', fromJson: DocsUserForBooking.fromJson)
  final DocsUserForBooking user;
  @JsonKey(name: 'org', fromJson: DocsOrganization.fromJson)
  final DocsOrganization org;
  @JsonKey(name: 'servicename', fromJson: DocsServiceName.fromJson)
  final DocsServiceName serviceName;

  @JsonKey(name: 'service', fromJson: DocsServiceForBooking.fromJson)
  final DocsServiceForBooking service;
  @JsonKey(name: "bookingdate")
  final DateTime bookingDate;
  @JsonKey(name: 'bookingtime', defaultValue: null)
  final DateTime? bookingTime;
  @JsonKey(name: "bookingstatus", defaultValue: 'Pending')
  final String bookingStatus;
  @JsonKey(name: 'location')
  final String location;
  @JsonKey(name: 'totalprice')
  final num totalPrice;
  @JsonKey(name: 'isActive')
  final bool isActive;
  @JsonKey(name: 'isPublished')
  final bool isPublished;
  @JsonKey(name: 'optionalContact', defaultValue: null)
  final String? optionalContact;
  @JsonKey(name: 'optionalEmail', defaultValue: null)
  final String? optionalEmail;

  DocsBooking({
    required this.id,
    required this.bookingDate,
    required this.bookingStatus,
    required this.org,
    required this.isActive,
    required this.location,
    required this.isPublished,
    required this.serviceName,
    required this.service,
    required this.totalPrice,
    required this.user,
    
    this.bookingTime,
    this.optionalContact,
    this.optionalEmail,
  });

  factory DocsBooking.fromJson(Map<String, dynamic> json) =>
      _$DocsBookingFromJson(json);

  Map<String, dynamic> toJson() => _$DocsBookingToJson(this);
}

//service name model for service name object in in response
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

//docs organization model for organization object in response
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

//service model for service object in response
@JsonSerializable()
class DocsServiceForBooking {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: "serviceprovidername")
  final String serviceProviderName;
  @JsonKey(name: 'serviceprovideremail')
  final String serviceProviderEmail;
  @JsonKey(name: "serviceproviderphone")
  final String serviceProviderPhoneNumber;

  @JsonKey(name: 'price')
  final num totalPrice;
  @JsonKey(name: 'img', defaultValue: null)
  final List<String>? images;

  DocsServiceForBooking({
    required this.id,
    required this.serviceProviderName,
    required this.serviceProviderEmail,
    required this.serviceProviderPhoneNumber,
    required this.totalPrice,
    this.images,
  });
  factory DocsServiceForBooking.fromJson(Map<String, dynamic> json) =>
      _$DocsServiceForBookingFromJson(json);

  Map<String, dynamic> toJson() => _$DocsServiceForBookingToJson(this);
}

@JsonSerializable()
class DocsUserForBooking {
  @JsonKey(name: '_id')
  final String userId;
  @JsonKey(name: 'name')
  final String userName;
  @JsonKey(name: 'email')
  final String userEmail;
  @JsonKey(name: 'phoneNumber')
  final String userPhoneNumber;
  @JsonKey(
    name: 'profile pic',
    defaultValue: null,
  )
  final String? profilePic;

  DocsUserForBooking({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhoneNumber,
    this.profilePic,
  });

  factory DocsUserForBooking.fromJson(Map<String, dynamic> json) =>
      _$DocsUserForBookingFromJson(json);

  Map<String, dynamic> toJson() => _$DocsUserForBookingToJson(this);
}
