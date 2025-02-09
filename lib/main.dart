import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/firebase_options.dart';
import 'package:suvidhaorg/models/bookings/booking_model.dart';
import 'package:suvidhaorg/models/organization_model/org.dart';
import 'package:suvidhaorg/providers/location_provider.dart';
import 'package:suvidhaorg/screens/booking/bookings_on_status.dart';
import 'package:suvidhaorg/screens/home.dart';
import 'package:suvidhaorg/screens/home/bookings.dart';
import 'package:suvidhaorg/screens/notification_screen.dart';
import 'package:suvidhaorg/screens/orders/order_details.dart';
import 'package:suvidhaorg/screens/orders/orders_on_status.dart';
import 'package:suvidhaorg/screens/reviews&ratings/all_review_rating.dart';
import 'package:suvidhaorg/screens/service_screens/offered_services.dart';
import 'package:suvidhaorg/screens/service_screens/service_names_screen.dart';
import 'package:suvidhaorg/screens/splash.dart';
import 'package:suvidhaorg/services/notification.dart';

import 'models/service_model/service_array_response.dart';
import 'providers/auth_provider.dart';
import 'providers/organization_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/booking/booking_details.dart';
import 'screens/organization_screens/add_organization.dart';
import 'screens/organization_screens/organization_details.dart';
import 'screens/organization_screens/update_organization.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/profile_content.dart';
import 'screens/service_screens/add_service.dart';
import 'screens/service_screens/service_details.dart';
import 'services/backend_service.dart';
import 'services/custom_hive.dart';

//global navigator key

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CustomHive().init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final backendService = BackendService();
  final notificationService = NotificationService(backendService);
  await notificationService.initialize();

  runApp(ProviderWrappedApp(
    notificationService: notificationService,
  ));
}

class ProviderWrappedApp extends StatelessWidget {
  const ProviderWrappedApp({super.key, required this.notificationService});
  final NotificationService notificationService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BackendService()),
        ChangeNotifierProvider(create: (_) => AuthProvider(_)),
        ChangeNotifierProvider(create: (_) => IndexProvider()),
        ChangeNotifierProvider(
          create: (_) => notificationService,
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(create: (_) => OrganizationProvider(_)),
        ChangeNotifierProvider(
          create: (_) => BookingProvider(_),
        ),
      ],
      child: MyApp(),
    );
  }
}

GoRouter _router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Splash(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileContent(),
    ),
    GoRoute(
      path: '/add_organization',
      builder: (context, state) => AddOrganizationScreen(),
    ),
    GoRoute(
      path: '/organization_details',
      builder: (context, state) {
        return OrganizationDetailsScreen();
      },
    ),
    GoRoute(
      path: '/update_organization',
      builder: (context, state) {
        final organization = state.extra as OrganizationModel;
        return UpdateOrganizationScreen(
          organization: organization,
        );
      },
    ),
    GoRoute(
      path: '/add_service/:serviceNameId',
      builder: (context, state) {
        final serviceNameId = state.pathParameters['serviceNameId']!;
        return AddServiceScreen(
          serviceNameId: serviceNameId,
        );
      },
    ),
    GoRoute(
      path: '/service_names',
      builder: (context, state) => const ServiceNameScreen(),
    ),
    GoRoute(
      path: '/service_list',
      builder: (context, state) {
        final services = state.extra as List<DocsService>;
        return OfferedServicesScreen(services: services);
      },
    ),
    GoRoute(
      path: '/service_details',
      builder: (context, state) {
        final services = state.extra as DocsService;
        return ServiceDetailsScreen(service: services);
      },
    ),
    GoRoute(
      path: '/booking_details',
      builder: (context, state) {
        final booking = state.extra as DocsBooking;
        return BookingDetailsScreen(booking: booking);
      },
    ),

    //pending bookings
    GoRoute(
      path: '/bookings_on_status',
      builder: (context, state) {
        final status = state.extra as String;
        return BookingsOnStatusScreen(status: status);
      },
    ),

    //order on status
    GoRoute(
      path: '/orders_on_status',
      builder: (context, state) {
        final status = state.extra as String;
        return OrdersOnStatusScreen(status: status);
      },
    ),
    //order by id
    GoRoute(
      path: '/order/:id',
      builder: (context, state) {
        final oid = state.pathParameters['id']!;
        return OrderDetailScreen(orderId: oid);
      },
    ),

    //goroute
    GoRoute(
      path: '/notifications',
      builder: (context, state) => NotificationScreen(),
    ),

    //goroute
    GoRoute(
      path: '/reviews',
      builder: (context, state) => const ReviewRatingScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Suvidha Sewa',
      themeMode: context.watch<ThemeProvider>().themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: suvidhaWhite,
        colorScheme: ColorScheme.light(
          primary: Color(0xFF6200EE),
          secondary: Color(0xFF03DAC6),
          surface: Colors.white,
          error: Color(0xFFB00020),
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onError: Colors.white,
          primaryContainer: Color(0xFF2E4E90),
          brightness: Brightness.light,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        cardTheme: CardTheme(
            elevation: 0,
            margin: EdgeInsets.all(2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            color: Color(0xFFFFFFFF).withOpacity(0.99)),
        dividerTheme: const DividerThemeData(
          space: 0,
          thickness: 2,
          color: Colors.black12,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 16),
            ),
            backgroundColor: const WidgetStatePropertyAll<Color>(
              Colors.lightGreen,
            ),
            foregroundColor: const WidgetStatePropertyAll<Color>(
              Colors.white,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            minimumSize: const WidgetStatePropertyAll(
              Size(double.infinity, 50),
            ),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: suvidhaWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.black.withOpacity(0.8),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: suvidhaDarkScaffold,
        fontFamily: 'Euclid',
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFBB46FC),
          secondary: Color(0xFF03DAC6),
          surface: Color(0xFF121212),
          error: Color(0xFFCF6679),
          onPrimary: Colors.black,
          primaryContainer: Colors.green,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onError: Colors.black,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: suvidhaDarkScaffold,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        dividerTheme: const DividerThemeData(
          space: 0,
          thickness: 1,
          color: Color(0xFFE0E0E0),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 16),
            ),
            backgroundColor:
                const WidgetStatePropertyAll<Color>(Colors.lightGreen),
            foregroundColor: const WidgetStatePropertyAll<Color>(
              Colors.white,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            minimumSize: const WidgetStatePropertyAll(
              Size(double.infinity, 50),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white.withOpacity(0.8),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          color: suvidhaDark,
        ),
        cardTheme: const CardTheme(
          elevation: 0,
          margin: EdgeInsets.all(2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          color: suvidhaDark,
        ),
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
