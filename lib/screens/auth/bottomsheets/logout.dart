import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/services/backend_service.dart';
import 'package:suvidhaorg/services/custom_hive.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';
import 'package:suvidhaorg/widgets/form_bottom_sheet_header.dart';

class LogoutProvider extends ChangeNotifier {
  final BuildContext context;

  LogoutProvider(this.context){
    _getFCMToken();
    authService = Provider.of<BackendService>(context);
  }
late BackendService authService;
  CustomHive _customHive = CustomHive();

  String? fcmToken;

  _getFCMToken() {
    fcmToken = _customHive.getFCMToken();
  }
  Future<void> logout() async {
    if(fcmToken != null) {
      await authService.removeFcmToken(fcmToken: fcmToken!);
    }
    await _customHive.deleteToken();

    context.go('/');
    notifyListeners();
  }
}

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) =>const  LogoutScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LogoutProvider(context),
      builder: (context, child) => Consumer<LogoutProvider>(
        builder: (context, provider, child) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               const  FormBottomSheetHeader(title: 'Logout'),
             const    SizedBox(
                  height: 10,
                ),
                Text(
                  'Are you sure you want to logout?',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              const   SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: 'Cancel',
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ),
                   const  SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomButton(
                        label: 'Logout',
                        onPressed: provider.logout,
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
             const   SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
