import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'backend_service.dart';
import 'custom_hive.dart';


FirebaseMessaging _messaging = FirebaseMessaging.instance;

class NotificationService extends ChangeNotifier {
  NotificationSettings? _settings;
  BackendService authService;

  NotificationService(this.authService);
  final CustomHive _customHive = CustomHive();

  bool get canAskPermission =>
      _settings?.authorizationStatus == AuthorizationStatus.notDetermined;

  bool get isNotificationEnabled => [
        AuthorizationStatus.authorized,
        AuthorizationStatus.provisional,
      ].contains(_settings?.authorizationStatus);

  Future<void> initilize() async {
    final isSupported = await _messaging.isSupported();
    if (!isSupported) return;
    _settings = await _messaging.getNotificationSettings();
    notifyListeners();
  }

  Future<void> requestPermission() async {
    _settings = await _messaging.requestPermission();
          //understand wha the user did
    if (_settings?.authorizationStatus == AuthorizationStatus.authorized) {
      sendFCMToken();
    }


    notifyListeners();
  }

  Future<void> sendFCMToken() async {
    final isSupported = await _messaging.isSupported();

    if (!isSupported) return;
    if (!isNotificationEnabled) return;

    final token = await _messaging.getToken();
    if (token == null) return;

    if (_customHive.getFCMToken() == token) return;

    final resp = await  authService.addFcmToken(fcmToken: token);
    if (resp.statusCode == 200) {
      debugPrint('FCM Token sent');
      await _customHive.saveFCMToken(token);
    }
  }
}
