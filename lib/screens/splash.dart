import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:suvidhaorg/providers/auth_provider.dart';
import 'package:suvidhaorg/providers/theme_provider.dart';

import '../models/auth_models/auth_token.dart';
import '../services/custom_hive.dart';
import '../services/notification.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AuthProvider _authProvider;
  bool loading = false;

  void _handleRouting() async {
    AuthToken? token =  CustomHive().getAuthToken();
    if (token == null) {
      if (mounted) context.go("/login");
    } else {
      await _authProvider.fetchUserDetails().then((e) async {
        context.go('/home');
        context.read<NotificationService>().sendFCMToken();
      }).catchError((e) async {

        await Future.delayed(const Duration(seconds: 5));
        _handleRouting();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: primaryDark,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlayAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              builder: (context, value, _) => Transform.scale(
                scale: Curves.easeOutQuad.transform(value),
                child: Hero(
                  tag: 'logo',
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icon/app_icon.png',
                        height: 200,
                      ),
                           Text('सुविधा सेवा',
                           style: Theme.of(context).textTheme.displayMedium?.copyWith(
                             color: suvidhaWhite,
                           ),

                           ),
                           Text(
                            'घरमै सेवा, तपाइको सेवा हाम्रो प्राथमिकता',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                             color: Colors.amber[600],
                              fontStyle: FontStyle.italic,
                  ),
                   ),
                    ],
                  ),
                ),
              ),
              onCompleted: () async {
                setState(() {
                  loading = true;
                });
                await context.read<NotificationService>().initilize();
                await Future.delayed(const Duration(seconds: 1));
                _handleRouting();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Opacity(
                opacity: loading ? 1 : 0,
                child: LoopAnimationBuilder(
                  tween: ColorTween(begin: primary, end: secondary),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) => LinearProgressIndicator(
                    color: value,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
