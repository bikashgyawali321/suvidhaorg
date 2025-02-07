import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/extensions/extensions.dart';
import 'package:suvidhaorg/models/offered_service.dart';
import 'package:suvidhaorg/providers/theme_provider.dart';
import 'package:suvidhaorg/screens/ask_permission.dart';
import 'package:suvidhaorg/screens/home/bookings.dart';
import 'package:suvidhaorg/screens/home/dashboard.dart';
import 'package:suvidhaorg/screens/home/orders.dart';
import 'package:suvidhaorg/screens/profile_content.dart';
import 'package:suvidhaorg/services/notification.dart';

import '../providers/auth_provider.dart';
import '../providers/organization_provider.dart';

class IndexProvider extends ChangeNotifier {
  int _index = 1;
  int get index => _index;
  void changeIndex(int index) {
    _index = index;
    notifyListeners();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final OfferedServiceList offeredServiceList = OfferedServiceList();
  late TabController _tabController;
  late Timer _timer;
  late OrganizationProvider organizationProvider;
  String currentDateTime = DateTime.now().toLocal().toVerbalDateTime;
  NotificationService get _notificationService =>
      context.read<NotificationService>();
  @override
  void initState() {
    organizationProvider = context.read<OrganizationProvider>();
    _timer = Timer.periodic(
        const Duration(
          seconds: 5,
        ), (timer) {
      setState(() {
        organizationProvider.getOrganizationData();
        currentDateTime = DateTime.now().toLocal().toVerbalDateTimeWithDay;
      });
    });
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
    final indexProvider = context.watch<IndexProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suvidha Sewa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: indexProvider.index == 1
              ? Text(
                  DateTime.now().toLocal().toVerbalDateTimeWithDay,
                )
              : SizedBox(),
        ),
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
                      radius: 35,
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
                    Flexible(
                      flex: 3,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RatingBarIndicator(
                            itemBuilder: (context, index) {
                              return Icon(
                                Icons.star,
                                color: Colors.amber,
                              );
                            },
                            rating: organizationProvider.organization?.rating
                                    ?.toDouble() ??
                                0,
                            itemCount: 5,
                            itemSize: 20,
                            unratedColor: Colors.grey,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            '(${organizationProvider.organization?.rating?.toStringAsFixed(2) ?? '0.0'}/5)',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: suvidhaWhite,
                                ),
                          ),
                        ],
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
            index: indexProvider.index,
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
                height: MediaQuery.of(context).size.height * 0.078,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? suvidhaDark
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => indexProvider.changeIndex(0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.event,
                                size: indexProvider.index == 0 ? 30 : 25,
                                color: indexProvider.index == 0
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              Text(
                                'Bookings',
                                style: TextStyle(
                                  color: indexProvider.index == 0
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: indexProvider.index == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => indexProvider.changeIndex(1),
                          child: Column(
                            children: [
                              Icon(
                                Icons.house,
                                size: indexProvider.index == 1 ? 30 : 25,
                                color: indexProvider.index == 1
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              Text(
                                'Home',
                                style: TextStyle(
                                  color: indexProvider.index == 1
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: indexProvider.index == 1
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => indexProvider.changeIndex(2),
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                size: indexProvider.index == 2 ? 30 : 25,
                                color: indexProvider.index == 2
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              Text(
                                'Orders',
                                style: TextStyle(
                                  color: indexProvider.index == 2
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: indexProvider.index == 2
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
            ),
          )
        ],
      ),
    );
  }
}
