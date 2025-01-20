import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/services/backend_service.dart';

import '../models/organization_model/org.dart';

class OrganizationProvider extends ChangeNotifier {
  late BackendService backendService;
  final BuildContext context;
  OrganizationModel? organization;

  bool loading = false;

  OrganizationProvider(this.context)
      : backendService = Provider.of<BackendService>(context, listen: false);
  String? organizationId;

  //get the organization details
  Future<void> getOrganizationDetails() async {
    final response = await backendService.getOrganization();
    organization = OrganizationModel.fromJson(response.result);
    notifyListeners();
  }

  //function to request organization verification
  Future<void> sendVerificationRequest(String orgId) async {
    try {
      loading = true;
      notifyListeners();
      if (organizationId != null) return;
      final response = await backendService.requestOrgVerification(
        orgId: orgId,
      );

      if (response.statusCode == 200 && response.errorMessage == null) {
        loading = false;
        organization = OrganizationModel.fromJson(response.result);
        notifyListeners();
        context.go('/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message!),
          ),
        );
        notifyListeners();
      } else {
        context.go('/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.errorMessage ??
                'Something went wrong, please try again later.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error in sending verification request");
      loading = false;
      notifyListeners();
    }
  }
}
