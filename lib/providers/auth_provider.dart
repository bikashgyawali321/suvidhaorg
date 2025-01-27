import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/models/auth_models/user_model.dart';
import 'package:suvidhaorg/services/backend_service.dart';
import 'package:suvidhaorg/widgets/snackbar.dart';

import '../models/backend_response.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? user;
  final BackendService service;
  final BuildContext context;

  bool loading = false;

  AuthProvider(this.context)
      : service = Provider.of<BackendService>(context, listen: false);
  String? error;

  Future<void> fetchUserDetails(BuildContext context) async {
    loading = true;
    notifyListeners();

    try {
      BackendResponse response = await service.getUserDetails();

      if (response.result != null && response.statusCode == 200) {
        user = UserModel.fromJson(response.result);
        if (user!.role != 'Organization') {
          context.go('/login');
          SnackBarHelper.showSnackbar(
            context: context,
            warningMessage:
                'You are not authorized to access this app, please login with organization account',
          );
          return;
        }
        context.go('/home');
        debugPrint("User details: ${user!.name}");
      } else {
        context.go('/login');
        throw Exception(response.errorMessage);
      }
      error = response.message;
      notifyListeners();
    } catch (e) {
      context.go('/login');
      debugPrint("Exception while fetching user details: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //function to refresh the auth token
}
