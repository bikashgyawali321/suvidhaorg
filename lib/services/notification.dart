import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suvidhaorg/main.dart';
import 'package:suvidhaorg/services/backend_service.dart';
import 'package:suvidhaorg/services/custom_hive.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';
import 'package:suvidhaorg/widgets/form_bottom_sheet_header.dart';

import '../models/notification_model.dart';

FirebaseMessaging _messaging = FirebaseMessaging.instance;

class NotificationService extends ChangeNotifier {
  late NotificationSettings? _settings;
  BackendService backendService;
  final CustomHive _customHive = CustomHive();

  NotificationService(this.backendService);

  bool get canAskPermission =>
      _settings?.authorizationStatus == AuthorizationStatus.notDetermined ||
      _settings?.authorizationStatus == AuthorizationStatus.denied;

  bool get isNotificationEnabled => [
        AuthorizationStatus.authorized,
        AuthorizationStatus.provisional,
      ].contains(_settings?.authorizationStatus);

  Future<void> initialize() async {
    final isSupported = await _messaging.isSupported();
    if (!isSupported) return;

    _settings = await _messaging.getNotificationSettings();

    FirebaseMessaging.onMessage.listen(_handleForegroundNotifications);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundNotifications);

    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotifications(initialMessage);
    }

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
      await sendFCMToken();
    }

    notifyListeners();
  }

  Future<void> sendFCMToken() async {
    final isSupported = await _messaging.isSupported();
    if (!isSupported || !isNotificationEnabled) return;

    final token = await _messaging.getToken();
    debugPrint('🔑 FCM Token: $token');

    if (token == null || _customHive.getFCMToken() == token) return;

    final resp = await backendService.addFcmToken(fcmToken: token);
    if (resp.statusCode == 200) {
      debugPrint('✅ FCM Token sent');
      await _customHive.saveFCMToken(token);
    }
  }

  void _handleForegroundNotifications(RemoteMessage message) async {
    if (message.data.isNotEmpty) {
      await _customHive.saveNotifications(
        NotificationModel(
          orderId: message.data['orderId'],
          data:
              message.notification?.body ?? 'You have an update on your order',
          date: DateTime.now(),
          title: message.notification?.title ?? 'Order Update',
          isRead: true,
        ),
      );
      debugPrint('📩 Foreground notification received: ${message.data}');
      _handleShowNotificationBottomSheet(message);
    }
  }

  void _handleBackgroundNotifications(RemoteMessage message) {
    debugPrint('📩 Background notification received: ${message.data}');
    final notification = NotificationModel(
      orderId: message.data['orderId'],
      data: message.notification?.body ?? 'You have a new order update',
      date: DateTime.now(),
      title: message.notification?.title ?? 'Order Update',
      isRead: false,
    );
    _customHive.saveNotifications(notification);
    _handleNotifications(message);
  }

  void _handleNotifications(RemoteMessage message) {
    if (navigatorKey.currentContext == null) return;

    final String? orderId = message.data['orderId'];
    if (orderId != null && orderId.isNotEmpty) {
      debugPrint('🔗 Navigating to order: $orderId');
      GoRouter.of(navigatorKey.currentContext!).go('/order/$orderId');
    } else {
      debugPrint('⚠️ No valid order ID found in notification');
    }
  }

  void _handleShowNotificationBottomSheet(RemoteMessage message) {
    if (navigatorKey.currentContext == null) return;

    final String? orderId = message.data['orderId'];

    showModalBottomSheet(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  FormBottomSheetHeader(
                    title: message.notification?.title ?? 'Notification',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    message.notification?.body ?? 'New Order Received',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'Reject',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          backgroundColor: Colors.redAccent,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomButton(
                          label: 'Accept',
                          onPressed: () {
                            if (orderId != null && orderId.isNotEmpty) {
                              acceptOrder(orderId);
                            } else {
                              debugPrint('⚠️ No valid order ID to accept');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> acceptOrder(String orderId) async {
    if (navigatorKey.currentContext == null) return;

    final resp = await backendService.acceptOrder(oid: orderId);
    if (resp.statusCode == 200) {
      print('Order accepted');
      GoRouter.of(navigatorKey.currentContext!).push('/order/$orderId');
    }

    notifyListeners();
  }
}
