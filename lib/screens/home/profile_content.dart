import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/screens/bottom_sheets/change_theme_bottom_sheet.dart';
import 'package:suvidhaorg/screens/home/organization_screens/request_organization_verification.dart';
import 'package:suvidhaorg/services/backend_service.dart';
import 'package:suvidhaorg/services/custom_hive.dart';
import 'package:suvidhaorg/widgets/custom_button_sheet.dart';
import 'package:suvidhaorg/widgets/snackbar.dart';

import '../../providers/organization_provider.dart';
import '../../providers/theme_provider.dart';
import '../auth/bottomsheets/change_password.dart';

class ProfileContentProvider extends ChangeNotifier {
  final BuildContext context;
  late BackendService backendService;
  late ThemeProvider themeProvider;
  late OrganizationProvider organizationProvider;
  ProfileContentProvider(this.context) {
    initialize();
  }
  void initialize() {
    backendService = Provider.of<BackendService>(context);
    organizationProvider = Provider.of<OrganizationProvider>(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    fcmToken = _customHive.getFCMToken();
  }

  String? fcmToken;
  bool loading = false;
  CustomHive _customHive = CustomHive();
  Future<void> logout() async {
    loading = true;
    notifyListeners();
    if (fcmToken != null) {
      await backendService.removeFcmToken(fcmToken: fcmToken!);
    }
    await _customHive.deleteToken();
    loading = false;
    context.go('/');
    notifyListeners();
  }

  Future<void> deleteOrganization() async {
    loading = true;
    notifyListeners();
    final response = await backendService.deleteOrganization();
    if (response.result != null && response.statusCode == 200) {
      organizationProvider.organization = null;
      context.pop();
      SnackbarHelper.showSnackbar(
        context: context,
        successMessage: response.message,
      );
    } else {
      loading = false;
      context.pop();
      SnackbarHelper.showSnackbar(
        context: context,
        errorMessage: response.errorMessage,
      );
      notifyListeners();
    }
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileContentProvider(context),
      builder: (context, child) => Consumer<ProfileContentProvider>(
        builder: (context, provider, child) => Column(
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
                      provider.organizationProvider.organization?.nameOrg ??
                          'Not Available',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      provider.organizationProvider.organization?.status ?? '',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  )
                ],
              ),
              leading: const Icon(Icons.business),
              onTap: provider.organizationProvider.organization == null
                  ? null
                  : () {
                      context.push(
                        '/organization_details',
                        extra: provider.organizationProvider.organization,
                      );
                    },
            ),
            if (provider.organizationProvider.organization != null) ...[
              ListTile(
                title: const Text('Update Organization'),
                leading: const Icon(Icons.update),
                onTap: () {
                  context.push(
                    '/update_organization',
                    extra: provider.organizationProvider.organization,
                  );
                },
              ),
              ListTile(
                title: const Text('Delete Organization'),
                leading: const Icon(Icons.delete),
                onTap: () {
                  CustomButtonSheet.show(
                    context: context,
                    title: 'Delete Organization',
                    positiveLabel: "Cancel",
                    negativeLabel: 'Delete',
                    onTap: provider.deleteOrganization,
                    message:
                        'Are you sure you want to delete your organization?',
                    loading: provider.loading,
                  );
                },
              ),
            ],
            if (provider.organizationProvider.organization != null &&
                provider.organizationProvider.organization?.status ==
                    "Pending") ...[
              ListTile(
                  title: Text('Request Verification'),
                  leading: Icon(Icons.request_page),
                  onTap: () {
                    RequestOrganizationVerification.show(
                      context,
                      provider.organizationProvider.organization!.id,
                    );
                  }),
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
              leading: Icon(provider.themeProvider.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : provider.themeProvider.themeMode == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.brightness_auto),
              onTap: () {
                ChangeThemeBottomSheet.show(context);
              },
              subtitle: Text(
                provider.themeProvider.themeMode == ThemeMode.dark
                    ? 'Dark'
                    : provider.themeProvider.themeMode == ThemeMode.light
                        ? 'Light'
                        : 'System',
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () => CustomButtonSheet.show(
                context: context,
                title: 'Logout',
                positiveLabel: "Cancel",
                negativeLabel: 'Logout',
                onTap: provider.logout,
                message: 'Are you sure you want to logout?',
                loading: provider.loading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
