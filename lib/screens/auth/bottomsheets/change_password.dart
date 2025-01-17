import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidha/services/backend_service.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/form_bottom_sheet_header.dart';

class ChangePasswordProvider extends ChangeNotifier {
  ChangePasswordProvider(this.context) {
    _authService = Provider.of<BackendService>(context, listen: false);
  }
  final BuildContext context;

  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';
  late BackendService _authService;
  bool loading = false;
  bool obsecureOldPassword = true;
  bool obsecureNewPassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    loading = true;
    notifyListeners();
    final response = await _authService.changePassword(
        newPassword: newPassword,
        oldPassword: oldPassword,
        confirmPassword: confirmPassword);
    if (response.statusCode == 200) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
        ),
      );

      loading = false;
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
        ),
      );
      loading = false;
      notifyListeners();
    }
  }

  void toggleOldPasswordVisibility() {
    obsecureOldPassword = !obsecureOldPassword;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    obsecureNewPassword = !obsecureNewPassword;
    notifyListeners();
  }
}

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  static Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        builder: (_) => ChangePassword());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordProvider(context),
      builder: (context, child) => Consumer<ChangePasswordProvider>(
        builder: (context, provider, child) => SafeArea(
            child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormBottomSheetHeader(title: 'Change Password'),
              const SizedBox(height: 10),
              Form(
                  key: provider._formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) {
                            provider.oldPassword = value;
                          },
                          decoration: InputDecoration(
                              labelText: 'Old Password',
                              suffixIcon: IconButton(
                                  onPressed:
                                      provider.toggleOldPasswordVisibility,
                                  icon: Icon(provider.obsecureOldPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility))),
                          obscureText: provider.obsecureOldPassword,
                          validator: (value) {
                            RegExp passwordRegex = RegExp(
                                r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{7,}$');
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (!passwordRegex.hasMatch(value)) {
                              return 'Password must be 7+ characters with a letter, number,\nand symbol.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          onChanged: (value) {
                            provider.newPassword = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'New password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                provider.obsecureNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: provider.toggleNewPasswordVisibility,
                            ),
                          ),
                          obscureText: provider.obsecureNewPassword,
                          validator: (value) {
                            RegExp passwordRegex = RegExp(
                                r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{7,}$');
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (!passwordRegex.hasMatch(value)) {
                              return 'Password must be 7+ characters with a letter, number,\nand symbol.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            provider.confirmPassword = value;
                          },
                          decoration: InputDecoration(
                            labelText: ' Confirm new password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                provider.obsecureNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: provider.toggleNewPasswordVisibility,
                            ),
                          ),
                          obscureText: provider.obsecureNewPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (value != provider.newPassword) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => provider.changePassword,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          onPressed: provider.changePassword,
                          label: 'Change Password',
                          loading: provider.loading,
                        )
                      ],
                    ),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
