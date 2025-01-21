import 'package:flutter/material.dart';
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
    if (response.result != null &&
        response.statusCode == 200 &&
        response.errorMessage == null) {
      organization = OrganizationModel.fromJson(response.result!);
      notifyListeners();
    } else {
      organization = null;
      notifyListeners();
    }
  }
}
