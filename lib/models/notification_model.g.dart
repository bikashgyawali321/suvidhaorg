// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      orderId: json['orderId'] as String,
      data: json['data'] as String,
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      isRead: json['isRead'] as bool,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'title': instance.title,
      'data': instance.data,
      'date': instance.date.toIso8601String(),
      'isRead': instance.isRead,
    };
