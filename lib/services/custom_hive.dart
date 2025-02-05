import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:suvidhaorg/models/auth_models/auth_token.dart';

import '../models/notification_model.dart';

class CustomHive {
  CustomHive._internal();

  static final CustomHive _customHive = CustomHive._internal();

  factory CustomHive() => _customHive;
  late final Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('suvidhaOrg');
  }

  //save auth tokens
  Future<void> saveAuthToken(AuthToken token) async {
    return await _box.put('auth_token', jsonEncode(token.toJson()));
  }

  //get auth tokens
  AuthToken? getAuthToken() {
    final token = _box.get('auth_token');
    if (token == null) return null;
    final decodedToken = jsonDecode(token);

    return AuthToken.fromJson(decodedToken);
  }

  //delete auth tokens
  Future<void> deleteToken() async {
    return await _box.delete('auth_token');
  }

  //save theme mode
  void saveThemeMode(ThemeMode themeMode) {
    _box.put('theme_mode', themeMode.index);
  }

  //get theme mode
  Future<ThemeMode> getThemeMode() async {
    final themeIndex =
        await _box.get('theme_mode', defaultValue: ThemeMode.light.index);

    return ThemeMode.values[themeIndex];
  }

  //save fcm token

  Future<void> saveFCMToken(String token) {
    return _box.put('fcmToken', jsonEncode(token));
  }

  //get fcm token
  String? getFCMToken() {
    String? encodedToken = _box.get('fcmToken');
    if (encodedToken == null) return null;
    String decodedToken = jsonDecode(encodedToken);
    return decodedToken;
  }

//add notifications
  Future<void> saveNotifications(NotificationModel notification) async {
    List<dynamic> encodedNotifications =
        _box.get('notifications', defaultValue: []);

    List<NotificationModel> notifications = encodedNotifications
        .map((encoded) => NotificationModel.fromJson(jsonDecode(encoded)))
        .toList();

    notifications.add(notification);
    List<String> updatedNotifications =
        notifications.map((notif) => jsonEncode(notif.toJson())).toList();

    await _box.put('notifications', updatedNotifications);
  }

  List<NotificationModel> getNotifications() {
    List<dynamic> encodedNotifications =
        _box.get('notifications', defaultValue: []);

    List<NotificationModel> notifications = encodedNotifications
        .map((encoded) => NotificationModel.fromJson(jsonDecode(encoded)))
        .toList();

    DateTime now = DateTime.now();

    notifications.removeWhere((notif) {
      if (now.difference(notif.date).inDays > 30) {
        _box.delete('notifications');
        return true;
      }
      return false;
    });

    _box.put('notifications',
        notifications.map((notif) => jsonEncode(notif.toJson())).toList());

    return notifications;
  }

  Future<void> deleteAllNotifications() async {
    await _box.delete('notifications');
  }

  Future<void> markNotificationAsRead(String orderId) async {
    List<String> encodedNotifications =
        _box.get('notifications', defaultValue: []);

    List<NotificationModel> notifications = encodedNotifications
        .map((encoded) => NotificationModel.fromJson(jsonDecode(encoded)))
        .toList();

    for (var notif in notifications) {
      if (notif.orderId == orderId) {
        notif.isRead = true;
        break;
      }
    }

    List<String> updatedNotifications =
        notifications.map((notif) => jsonEncode(notif.toJson())).toList();

    await _box.put('notifications', updatedNotifications);
  }
}
