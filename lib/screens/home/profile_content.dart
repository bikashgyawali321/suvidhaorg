import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/screens/auth/bottomsheets/logout.dart';
import 'package:suvidhaorg/screens/bottom_sheets/change_theme_bottom_sheet.dart';
import 'package:suvidhaorg/screens/home/organization_screens/request_organization_verification.dart';

import '../../providers/organization_provider.dart';
import '../../providers/theme_provider.dart';
import '../auth/bottomsheets/change_password.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final organizationProvider = Provider.of<OrganizationProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
          title: const Text('Your Organization'),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  organizationProvider.organization?.nameOrg ?? 'Not Available',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              Flexible(
                child: Text(
                  organizationProvider.organization?.status ?? '',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              )
            ],
          ),
          leading: const Icon(Icons.business),
          onTap: organizationProvider.organization == null
              ? null
              : () {
                  context.push(
                    '/organization_details',
                    extra: organizationProvider.organization,
                  );
                },
        ),
        if (organizationProvider.organization != null &&
            organizationProvider.organization?.status == "Pending") ...[
          ListTile(
            title: Text('Request Verification'),
            leading: Icon(Icons.request_page),
            onTap: () => RequestOrganizationVerification.show(
              context,
              organizationProvider.organization!.id,
            ),
          ),
        ],
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
    );
  }
}
