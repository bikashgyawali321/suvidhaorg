import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/models/organization_model/organization_data_response.dart';
import 'package:suvidhaorg/models/service_model/service_array_response.dart';
import 'package:suvidhaorg/services/backend_service.dart';

import '../models/organization_model/org.dart';

class OrganizationProvider extends ChangeNotifier {
  late BackendService backendService;
  final BuildContext context;
  OrganizationModel? organization;
  List<DocsService> services = [];
  ServiceArrayResponse? serviceArrayResponse;
  OrganizationDataResponse? organizationDataResponse;

  bool loading = false;

  OrganizationProvider(this.context) {
    backendService = context.read<BackendService>();
    getAllOrganizationServices();
  }
  String? organizationId;
  int index = 1;

  //change index
  void changeIndex(int newIndex) {
    index = newIndex;
    notifyListeners();
  }

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

  //get all services provided by the organization
  Future<void> getAllOrganizationServices() async {
    loading = true;
    notifyListeners();

    await getOrganizationDetails();
    if (organization == null) {
      loading = false;
      notifyListeners();
      return;
    }

    final response = await backendService.getAllServices(
      orgId: organizationId ?? organization!.id,
    );
    if (response.result != null &&
        response.statusCode == 200 &&
        response.errorMessage == null) {
      serviceArrayResponse = ServiceArrayResponse.fromJson(response.result);
      services = serviceArrayResponse!.docs;
      await getOrganizationData();
      loading = false;
      notifyListeners();
    } else {
      services = [];
      loading = false;
      notifyListeners();
    }
  }

  //get the data for dashboard

  Future<void> getOrganizationData() async {
    try {
      final response = await backendService.getOrganizationData();
      if (response.result != null &&
          response.statusCode == 200 &&
          response.errorMessage == null) {
        organizationDataResponse =
            OrganizationDataResponse.fromJson(response.result);
        notifyListeners();
      } else {
        organizationDataResponse = null;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Exception while fetching organization data: $e");
    }
  }
}
