import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/services/backend_service.dart';
import 'package:suvidhaorg/widgets/form_bottom_sheet_header.dart';
import 'package:suvidhaorg/widgets/snackbar.dart';

import '../../providers/organization_provider.dart';
import '../../widgets/custom_button.dart';

class RequestOrganizationVerificationProvider extends ChangeNotifier {
  final BuildContext context;
  bool loading = false;
  RequestOrganizationVerificationProvider(this.context, this.organizationId) {
    initialize();
  }
  String organizationId;
  late BackendService _backendService;
  late OrganizationProvider _organizationProvider;

  void initialize() {
    _backendService = Provider.of<BackendService>(context);
    _organizationProvider = Provider.of<OrganizationProvider>(context);
  }

  //send verification request
  Future<void> sendVerificatioRequest() async {
    loading = true;
    notifyListeners();
    final response =
        await _backendService.requestOrgVerification(orgId: organizationId);
    if (response.result != null && response.statusCode == 200) {
      _organizationProvider.getOrganizationDetails();
      context.pop();
      SnackBarHelper.showSnackbar(
        context: context,
        successMessage: response.message,
      );
    } else {
      context.pop();

      loading = false;
      SnackBarHelper.showSnackbar(
        context: context,
        errorMessage: response.errorMessage,
      );
      notifyListeners();
    }
  }
}

class RequestOrganizationVerification extends StatelessWidget {
  RequestOrganizationVerification({super.key, required this.organizationId});
  String? organizationId;

  static void show(BuildContext context, String organizationId) {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          RequestOrganizationVerification(organizationId: organizationId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrganizationProvider>(context);
    return ChangeNotifierProvider(
      create: (_) =>
          RequestOrganizationVerificationProvider(context, organizationId!),
      builder: (context, child) =>
          Consumer<RequestOrganizationVerificationProvider>(
        builder: (context, provider, child) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBottomSheetHeader(
                    title: 'Request Organization Verification'),
                const SizedBox(height: 15),
                Text(
                  'Your organization is not verified yet. Please request for verification.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () => context.pop(),
                        label: 'Not Now',
                        backgroundColor: Colors.red,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        onPressed: () => provider.sendVerificatioRequest(),
                        label: 'Request',
                        backgroundColor: Colors.blueAccent,
                        loading: orgProvider.loading,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
