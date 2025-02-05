import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/extensions/extensions.dart';

import '../models/notification_model.dart';
import '../services/custom_hive.dart';
import '../widgets/loading_screen.dart';

class NotificationScreenProvider extends ChangeNotifier {
  CustomHive _customHive = CustomHive();
  List<NotificationModel> notifications = [];
  bool loading = false;
  final BuildContext context;

  NotificationScreenProvider(this.context) {
    getAllNotifications();
  }
  //get all unread notifications
  void getAllNotifications() {
    loading = false;
    notifyListeners();
    final response = _customHive.getNotifications();
    notifications = response;
    notifications.sort((a, b) => a.isRead ? 1 : -1);
    loading = false;
    notifyListeners();
  }

  Future<void> markNotificationAsRead(String orderId) async {
    await _customHive.markNotificationAsRead(orderId);
    notifyListeners();
  }

  void deleteAllNotifications() {
    _customHive.deleteAllNotifications();
    notifyListeners();
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => NotificationScreenProvider(context),
        builder: (context, child) => Consumer<NotificationScreenProvider>(
          builder: (context, provider, child) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (provider.loading) LoadingScreen(),
                    if (provider.notifications.isEmpty) ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                          Center(
                            child: Icon(
                              Icons.notifications_off,
                              size: 70,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'No Active Notifications ',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Looks like there are no active notifications from the past 30 days",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      )
                    ],
                    for (final notification in provider.notifications) ...[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Theme.of(context).highlightColor,
                              child: Icon(
                                notification.isRead == true
                                    ? Icons.notifications
                                    : Icons.notifications_active,
                                size: 30,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            title: Text(
                              notification.title,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('View Details'),
                                Icon(
                                  Icons.chevron_right,
                                  size: 20,
                                ),
                              ],
                            ),
                            subtitle: Text(notification.date.toMarkerDate),
                            onTap: () async {
                              await provider
                                  .markNotificationAsRead(notification.orderId);
                              context.push('/order/${notification.orderId}');
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                    ]
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
