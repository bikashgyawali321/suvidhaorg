import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:suvidhaorg/services/backend_service.dart';
import 'package:suvidhaorg/services/custom_hive.dart';

FirebaseMessaging _messaging = FirebaseMessaging.instance;

class NotificationService extends ChangeNotifier {
  late NotificationSettings? _settings;

  BackendService authService;

  NotificationService(this.authService);
  final CustomHive _customHive = CustomHive();

  bool get canAskPermission =>
      _settings?.authorizationStatus == AuthorizationStatus.notDetermined ||
      _settings?.authorizationStatus == AuthorizationStatus.denied;
  bool get isNotificationEnabled => [
        AuthorizationStatus.authorized,
        AuthorizationStatus.provisional,
      ].contains(
        _settings?.authorizationStatus,
      );

  Future<void> initilize() async {
    final isSupported = await _messaging.isSupported();
    if (!isSupported) return;
    _settings = await _messaging.getNotificationSettings();

    // canAskPermission == true;
    notifyListeners();
  }

  Future<void> requestPermission() async {
    _settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    if (_settings?.authorizationStatus == AuthorizationStatus.authorized) {
      sendFCMToken();
    }

    notifyListeners();
  }

  Future<void> sendFCMToken() async {
    final isSupported = await _messaging.isSupported();
    print('isSupported: $isSupported');

    if (!isSupported) return;
    if (!isNotificationEnabled) return;

    final token = await _messaging.getToken();
    if (token == null) return;

    if (_customHive.getFCMToken() == token) return;

    final resp = await authService.addFcmToken(fcmToken: token);
    if (resp.statusCode == 200) {
      debugPrint('FCM Token sent');
      await _customHive.saveFCMToken(token);
    }
  }
}
