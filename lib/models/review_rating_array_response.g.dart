// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_rating_array_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewRatingArrayResponse _$ReviewRatingArrayResponseFromJson(
        Map<String, dynamic> json) =>
    ReviewRatingArrayResponse(
      pagination:
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      docs: ReviewRatingArrayResponse._docsReviewRatingFromJson(
          json['docs'] as List),
    );

Map<String, dynamic> _$ReviewRatingArrayResponseToJson(
        ReviewRatingArrayResponse instance) =>
    <String, dynamic>{
      'pagination': instance.pagination,
      'docs': ReviewRatingArrayResponse._docsReviewRatingToJson(instance.docs),
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

DocsServiceNameForReviewRating _$DocsServiceNameForReviewRatingFromJson(
        Map<String, dynamic> json) =>
    DocsServiceNameForReviewRating(
      id: json['_id'] as String,
      name: json['name'] as String,
      serviceCode: json['servicecode'] as String,
    );

Map<String, dynamic> _$DocsServiceNameForReviewRatingToJson(
        DocsServiceNameForReviewRating instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'servicecode': instance.serviceCode,
    };

DocsServiceForReviewRating _$DocsServiceForReviewRatingFromJson(
        Map<String, dynamic> json) =>
    DocsServiceForReviewRating(
      id: json['_id'] as String,
      serviceProviderName: json['serviceprovidername'] as String,
      serviceProviderEmail: json['serviceprovideremail'] as String,
      serviceProviderPhone: json['serviceproviderphone'] as String,
      img: (json['img'] as List<dynamic>).map((e) => e as String).toList(),
      rating: json['rating'] as num,
    );

Map<String, dynamic> _$DocsServiceForReviewRatingToJson(
        DocsServiceForReviewRating instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'serviceprovidername': instance.serviceProviderName,
      'serviceprovideremail': instance.serviceProviderEmail,
      'serviceproviderphone': instance.serviceProviderPhone,
      'img': instance.img,
      'rating': instance.rating,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      id: json['_id'] as String,
      name: json['name'] as String,
      profilePic: json['profilePic'] as String?,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'profilePic': instance.profilePic,
    };

DocsReviewRating _$DocsReviewRatingFromJson(Map<String, dynamic> json) =>
    DocsReviewRating(
      id: json['_id'] as String,
      userId: json['user'] as String,
      user: UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
      serviceName: DocsServiceNameForReviewRating.fromJson(
          json['servicenames'] as Map<String, dynamic>),
      serviceNameId: json['serviceName'] as String,
      rating: json['rating'] as num,
      service: DocsServiceForReviewRating.fromJson(
          json['service'] as Map<String, dynamic>),
      review: json['review'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DocsReviewRatingToJson(DocsReviewRating instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.userId,
      'userInfo': instance.user,
      'servicenames': instance.serviceName,
      'serviceName': instance.serviceNameId,
      'rating': instance.rating,
      'service': instance.service,
      'review': instance.review,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
