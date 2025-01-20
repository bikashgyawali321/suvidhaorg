import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/firebase_options.dart';
import 'package:suvidhaorg/models/organization_model/org.dart';
import 'package:suvidhaorg/screens/home/home.dart';
import 'package:suvidhaorg/screens/splash.dart';

import 'providers/auth_provider.dart';
import 'providers/organization_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home/organization_screens/add_organization.dart';
import 'screens/home/organization_screens/organization_details.dart';
import 'screens/home/profile_content.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'services/backend_service.dart';
import 'services/custom_hive.dart';
import 'services/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptionsAndroid.currentPlatform,
  );
  await CustomHive().init();
  runApp(const ProviderWrappedApp());
}

class ProviderWrappedApp extends StatelessWidget {
  const ProviderWrappedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BackendService()),
        ChangeNotifierProvider(create: (_) => AuthProvider(_)),
        ChangeNotifierProvider(
          create: (_) => NotificationService(_.read<BackendService>()),
        ),
        ChangeNotifierProvider(create: (_) => OrganizationProvider(_)),
      ],
      child: MyApp(),
    );
  }
}

GoRouter _router = GoRouter(
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
        final organization = state.extra as OrganizationModel;
        return OrganizationDetailsScreen(organizationModel: organization);
      },
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'सुविधा',
      themeMode: context.watch<ThemeProvider>().themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6200EE),
          secondary: Color(0xFF03DAC6),
          surface: Colors.white,
          error: Color(0xFFB00020),
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onError: Colors.white,
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
        cardTheme: const CardTheme(
          elevation: 0,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          color: suvidhaWhite,
        ),
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
          color: primaryDark,
          iconTheme: IconThemeData(
            color: suvidhaWhite,
          ),
          titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: suvidhaWhite,
                
              ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Euclid',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFBB86FC),
          secondary: Color(0xFF03DAC6),
          surface: Color(0xFF121212),
          error: Color(0xFFCF6679),
          onPrimary: Colors.black,
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
          color: primaryDark,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        cardTheme: const CardTheme(
          elevation: 0,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
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
