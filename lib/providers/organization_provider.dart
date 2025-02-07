import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/models/organization_model/organization_data_response.dart';
import 'package:suvidhaorg/models/pagination/list_model.dart';
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

  int get requestedOrders =>
      organizationDataResponse?.pendingOrders.toInt() ?? 0;
  int get totalServices => organizationDataResponse?.totalServices.toInt() ?? 0;
  int get totalBookings => organizationDataResponse?.totalBookings.toInt() ?? 0;
  int get pendingBookings =>
      organizationDataResponse?.pendingBookings.toInt() ?? 0;
  int get acceptedBookings =>
      organizationDataResponse?.acceptedBookings.toInt() ?? 0;
  int get completedBookings =>
      organizationDataResponse?.completedBookings.toInt() ?? 0;
  int get totalOrders => organizationDataResponse?.totalOrders.toInt() ?? 0;
  int get acceptedOrders =>
      organizationDataResponse?.acceptedOrders.toInt() ?? 0;
  int get completedOrders =>
      organizationDataResponse?.completedOrders.toInt() ?? 0;
  int get rejectedBookings =>
      organizationDataResponse?.rejectedBookings.toInt() ?? 0;
  int get pendingOrders => organizationDataResponse?.pendingOrders.toInt() ?? 0;

  bool loading = false;

  OrganizationProvider(this.context) {
    backendService = context.read<BackendService>();
    getAllOrganizationServices();
  }
  String? organizationId;

  //change index
  ListingSchema listingSchema = ListingSchema(
    page: 1,
    limit: 100,
  );
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
      listingSchema: listingSchema,
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
    if (organization == null) {
      return;
    }
    try {
      final response = await backendService.getOrganizationData();
      if (response.result != null &&
          response.statusCode == 200 &&
          response.errorMessage == null) {
        organizationDataResponse =
            OrganizationDataResponse.fromJson(response.result);

        notifyListeners();
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
