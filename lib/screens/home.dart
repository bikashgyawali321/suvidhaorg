import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/models/offered_service.dart';
import 'package:suvidhaorg/providers/theme_provider.dart';
import 'package:suvidhaorg/screens/ask_permission%20copy.dart';
import 'package:suvidhaorg/screens/home/bookings.dart';
import 'package:suvidhaorg/screens/home/dashboard.dart';
import 'package:suvidhaorg/screens/home/orders.dart';
import 'package:suvidhaorg/screens/profile_content.dart';
import 'package:suvidhaorg/services/notification.dart';

import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final OfferedServiceList offeredServiceList = OfferedServiceList();
  int index = 1;
  late TabController _tabController;
  NotificationService get _notificationService =>
      context.read<NotificationService>();
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    if (_notificationService.canAskPermission) {
      Future.delayed(const Duration(seconds: 2)).then((e) {
        AskPermission.show(context);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suvidha Sewa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: primaryDark,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: suvidhaWhite,
                      child: Icon(
                        Icons.business,
                        size: 50,
                        color: primaryIconColor,
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Text(
                        authProvider.user?.name ?? 'N/A',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: suvidhaWhite,
                            ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Text(
                        authProvider.user?.email ?? 'N/A',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: suvidhaWhite,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const ProfileContent(),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: index,
            children: const [
              BookingScreen(),
              DashboardScreen(),
              OrdersScreen(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.075,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? suvidhaDark
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          index = 0;
                        }),
                        child: Column(
                          children: [
                            Icon(
                              Icons.event,
                              size: index == 0 ? 30 : 25,
                              color: index == 0
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            Text(
                              'Bookings',
                              style: TextStyle(
                                color: index == 0
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: index == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          index = 1;
                        }),
                        child: Column(
                          children: [
                            Icon(
                              Icons.house,
                              size: index == 1 ? 30 : 25,
                              color: index == 1
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            Text(
                              'Home',
                              style: TextStyle(
                                color: index == 1
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: index == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          index = 2;
                        }),
                        child: Column(
                          children: [
                            Icon(
                              Icons.history,
                              size: index == 2 ? 30 : 25,
                              color: index == 2
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            Text(
                              'Orders',
                              style: TextStyle(
                                color: index == 2
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: index == 2
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
