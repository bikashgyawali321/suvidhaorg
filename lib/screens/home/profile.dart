import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suvidha/screens/auth/bottomsheets/logout.dart';
import 'package:suvidha/screens/bottom_sheets/change_theme_bottom_sheet.dart';

import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../auth/bottomsheets/change_password.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
          ),
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            CircleAvatar(
              radius: 70,
              backgroundColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(.2),
            ),
            SizedBox(
              height: 20,
            ),
            Text(authProvider.user?.name ?? 'N/A',
                style: Theme.of(context).textTheme.titleLarge),
            Text(
              authProvider.user?.email ?? 'N/A',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            ListTile(
              title: const Text('Edit Profile'),
              leading: const Icon(Icons.manage_accounts_outlined),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Change Password'),
              leading: const Icon(Icons.password),
              onTap: () {
                ChangePassword.show(context);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Orders History'),
              leading: const Icon(Icons.history),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Ongoing Orders'),
              leading: const Icon(Icons.delivery_dining),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Change Theme'),
              leading: Icon(themeProvider.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : themeProvider.themeMode == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.brightness_auto),
              onTap: () {
                ChangeThemeBottomSheet.show(context);
              },
              subtitle: Text(
                themeProvider.themeMode == ThemeMode.dark
                    ? 'Dark'
                    : themeProvider.themeMode == ThemeMode.light
                        ? 'Light'
                        : 'System',
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () async {
                LogoutScreen.show(context);
              },
            ),
          ],
        )));
  }
}
