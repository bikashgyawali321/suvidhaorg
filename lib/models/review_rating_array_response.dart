import 'package:json_annotation/json_annotation.dart';


part 'review_rating_array_response.g.dart';

@JsonSerializable()
class ReviewRatingArrayResponse {
  @JsonKey(name: 'pagination', fromJson: Pagination.fromJson)
  final Pagination pagination;

  @JsonKey(
      name: 'docs',
      fromJson: _docsReviewRatingFromJson,
      toJson: _docsReviewRatingToJson)
  List<DocsReviewRating> docs;
  ReviewRatingArrayResponse({required this.pagination, required this.docs});

  factory ReviewRatingArrayResponse.fromJson(Map<String, dynamic> json) =>
      _$ReviewRatingArrayResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewRatingArrayResponseToJson(this);

  static List<DocsReviewRating> _docsReviewRatingFromJson(List<dynamic> json) =>
      json
          .map((e) => DocsReviewRating.fromJson(e as Map<String, dynamic>))
          .toList();

  static List<Map<String, dynamic>> _docsReviewRatingToJson(
          List<DocsReviewRating> docs) =>
      docs.map((e) => e.toJson()).toList();
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

@JsonSerializable()
class DocsServiceNameForReviewRating {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'servicecode')
  final String serviceCode;

  DocsServiceNameForReviewRating({
    required this.id,
    required this.name,
    required this.serviceCode,
  });

  factory DocsServiceNameForReviewRating.fromJson(Map<String, dynamic> json) =>
      _$DocsServiceNameForReviewRatingFromJson(json);

  Map<String, dynamic> toJson() => _$DocsServiceNameForReviewRatingToJson(this);
}

@JsonSerializable()
class DocsServiceForReviewRating {
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
  final num rating;

  DocsServiceForReviewRating({
    required this.id,
    required this.serviceProviderName,
    required this.serviceProviderEmail,
    required this.serviceProviderPhone,
    required this.img,
    required this.rating,
  });

  factory DocsServiceForReviewRating.fromJson(Map<String, dynamic> json) =>
      _$DocsServiceForReviewRatingFromJson(json);

  Map<String, dynamic> toJson() => _$DocsServiceForReviewRatingToJson(this);
}

@JsonSerializable()
class UserInfo {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(
    name: 'profilePic',
    defaultValue: null,
  )
  final String? profilePic;

  UserInfo({
    required this.id,
    required this.name,
    this.profilePic,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@JsonSerializable()
class DocsReviewRating {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'user')
  final String userId;
  @JsonKey(name: "userInfo")
  final UserInfo user;
  @JsonKey(name: 'servicenames')
  final DocsServiceNameForReviewRating serviceName;
  @JsonKey(name: 'serviceName')
  final String serviceNameId;
  @JsonKey(name: 'rating')
  final num rating;
  @JsonKey(name: 'service')
  final DocsServiceForReviewRating service;

  @JsonKey(name: 'review', defaultValue: null)
  final String? review;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  DocsReviewRating({
    required this.id,
    required this.userId,
    required this.user,
    required this.serviceName,
    required this.serviceNameId,
    required this.rating,
    required this.service,
    this.review,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocsReviewRating.fromJson(Map<String, dynamic> json) =>
      _$DocsReviewRatingFromJson(json);

  Map<String, dynamic> toJson() => _$DocsReviewRatingToJson(this);
}
