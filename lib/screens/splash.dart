import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:simple_animations/simple_animations.dart';
import 'package:suvidha/models/auth_models/auth_token.dart';
import 'package:suvidha/providers/auth_provider.dart';

import '../providers/theme_provider.dart';
import '../services/custom_hive.dart';

class SplashProvider extends ChangeNotifier {
  final BuildContext context;
  bool loading = false;
  late AuthProvider authProvider;

  SplashProvider(this.context)
      : authProvider = Provider.of<AuthProvider>(context, listen: false);

  Future<void> handleRouting() async {
    loading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 7));
    // Get auth token from Hive
    AuthToken? authToken = CustomHive().getAuthToken();

    if (authToken == null) {
      // If token is null, navigate to login
      loading = false;
      notifyListeners();
      context.go('/login');
    } else {
      // Fetch user details if token exists
      try {
        await authProvider.fetchUserDetails();
        context.go('/home');
        loading = false;
        notifyListeners();
      } catch (e) {
        await Future.delayed(const Duration(seconds: 5));
        handleRouting();
      }
    }
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashProvider(context)..handleRouting(),
      child: Consumer<SplashProvider>(
        builder: (context, splashProvider, child) => Scaffold(
          backgroundColor: primaryDark,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlayAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, _) => Transform.scale(
                    scale: Curves.easeIn.transform(value),
                    child: Hero(
                      tag: 'logo',
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icon/app_icon.png',
                            height: 200,
                          ),
                          Text(
                            'सुविधा',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(color: suvidhaWhite),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'घरमै सेवा, तपाइको सेवा हाम्रो प्राथमिकता',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.amber[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: Opacity(
                    opacity: splashProvider.loading ? 1 : 0,
                    child: LoopAnimationBuilder(
                      tween: ColorTween(begin: primary, end: secondary),
                      duration: const Duration(seconds: 2),
                      builder: (context, value, child) =>
                          LinearProgressIndicator(
                        color: value,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
