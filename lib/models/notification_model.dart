import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String orderId;
  final String title;
  final String data;
  final DateTime date;
  bool isRead = false;

  NotificationModel({
    required this.orderId,
    required this.data,
    required this.date,
    required this.title,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
