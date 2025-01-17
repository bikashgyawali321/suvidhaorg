import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suvidha/models/auth_models/user_model.dart';
import 'package:suvidha/services/backend_service.dart';

import '../models/backend_response.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? user;
  final BackendService service;
  final BuildContext context;

  bool loading = false;

  AuthProvider(this.context)
      : service = Provider.of<BackendService>(context, listen: false);
  String? error;

  // Fetch user details from the backend
  Future<void> fetchUserDetails() async {
    loading = true;
    notifyListeners();

    try {
      BackendResponse response = await service.getUserDetails();

      if (response.data != null) {
        user = UserModel.fromJson(response.data);
        debugPrint("User details: ${user!.name}");
      } else {
        error = response.message;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Exception while fetching user details: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //function to refresh the auth token
}
