import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suvidha/services/backend_service.dart';

import '../../../widgets/custom_button.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  late BackendService authService;
  ForgotPasswordProvider(this.context, this.vsync) {
    authService = Provider.of<BackendService>(context);
    tabController = TabController(length: 3, vsync: vsync);
  }
  String email = '';
  num token = 0;
  String newPassword = '';
  String confirmPassword = '';
  bool loading = false;
  bool obsecureText = true;
  final formKey = GlobalKey<FormState>();
  late TabController tabController;
  final BuildContext context;
  final TickerProvider vsync;
  int tabIndex = 0;
  FocusNode focusNode = FocusNode();
  //toggle password visibility
  void togglePasswordVisibility() {
    obsecureText = !obsecureText;
    notifyListeners();
  }

  //set the tab  index
  void setTabIndex() {
    tabController.index = tabIndex;
    notifyListeners();
  }

  //send forgotPassword Request
  Future<void> sendForgotPasswordRequest() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    loading = true;
    notifyListeners();
    focusNode.unfocus();

    await Future.delayed(Duration(seconds: 3));
    tabController.animateTo(1,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    loading = false;
    await authService.sendForgotPasswordRequest(email: email);
    tabIndex = 1;

    //set the focus node to false
    focusNode.requestFocus();
    notifyListeners();
  }

  //verify otp
  Future<void> verifyForgotRequestToken() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    loading = true;
    notifyListeners();

    tabIndex = 2;
    await Future.delayed(Duration(seconds: 3));
    final response =
        await authService.verifyResetPasswordToken(email: email, token: token);

    if (response.statusCode == 200) {
      tabController.animateTo(2,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      loading = false;
      focusNode.unfocus();
      notifyListeners();
    } else {
      loading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
        ),
      );

      notifyListeners();
    }
  }

  //submit new password
  Future<void> resetPassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    loading = true;
    notifyListeners();
    focusNode.unfocus();
    final response = await authService.resetPassword(
      email: email,
      token: token,
      password: newPassword,
      confirmPassword: confirmPassword,
    );
    if (response.statusCode == 200) {
      await Future.delayed(Duration(seconds: 3));
      loading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
        ),
      );
      notifyListeners();
      //navigate to login screen
      Navigator.pop(context);
    } else {
      loading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.red,
        ),
      );
      notifyListeners();
    }
  }
}

class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({super.key});
  static Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => ForgotPasswordSheet());
  }

  @override
  _ForgotPasswordSheetState createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordProvider(context, this),
      child: Consumer<ForgotPasswordProvider>(
        builder: (context, provider, child) => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text('Forgot Password?',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(
                    'Let\'s reset it',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TabBar(
                  controller: provider.tabController,
                  labelPadding: EdgeInsets.only(right: 16),
                  onTap: (index) {
                    provider.setTabIndex();
                  },
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(
                      text: '1 Email',
                    ),
                    Tab(
                      text: '2 OTP',
                    ),
                    Tab(
                      text: '3 New Password',
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Form(
                      key: provider.formKey,
                      child: TabBarView(
                        controller: provider.tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Email field
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    provider.email = value;
                                  });
                                },
                                focusNode: provider.focusNode,
                                validator: (value) {
                                  RegExp emailRegex = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                                  if (value == null || value.isEmpty) {
                                    return "Email is required";
                                  }
                                  if (!emailRegex.hasMatch(value)) {
                                    return "Invalid email address";
                                  }

                                  return null;
                                },
                                autofocus: false,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              CustomButton(
                                label: 'Continue',
                                loading: provider.loading,
                                onPressed: provider.sendForgotPasswordRequest,
                              ),
                            ],
                          ),
                          // OTP field
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Verification code',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Enter the 6 digit verification code sent to ${provider.email}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: Colors.pink,
                                        fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    provider.token = num.parse(value);
                                  });
                                },
                                keyboardType: TextInputType.number,
                                autofocus: true,
                                focusNode: provider.focusNode,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "OTP is required";
                                  }
                                  if (value.length != 6) {
                                    return "OTP should be of 6 digits";
                                  }
                                  return null;
                                },
                                maxLength: 6,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                label: 'Verify',
                                loading: provider.loading,
                                onPressed: provider.verifyForgotRequestToken,
                              ),
                            ],
                          ),
                          // New password field
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'New Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(provider.obsecureText
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      provider.togglePasswordVisibility();
                                    },
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    provider.newPassword = value;
                                  });
                                },
                                focusNode: provider.focusNode,
                                validator: (value) {
                                  RegExp passwordRegex = RegExp(
                                      r'^(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{6,})');
                                  if (value == null || value.isEmpty) {
                                    return "Password is required";
                                  }

                                  if (!passwordRegex.hasMatch(value)) {
                                    return "Password must be 7+ characters with a letter, number,\nand symbol.'";
                                  }
                                  return null;
                                },
                                obscureText: provider.obsecureText,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(provider.obsecureText
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      provider.togglePasswordVisibility();
                                    },
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    provider.confirmPassword = value;
                                  });
                                  provider.confirmPassword = value;
                                },
                                validator: (value) {
                                  RegExp passwordRegex = RegExp(
                                      r'^(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{6,})');
                                  if (value == null || value.isEmpty) {
                                    return "Password is required";
                                  }
                                  if (!passwordRegex.hasMatch(value)) {
                                    return "Password must be 7+ characters with a letter, number,\nand symbol.'";
                                  }
                                  if (value != provider.newPassword) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                },
                                obscureText: provider.obsecureText,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                label: 'Submit',
                                onPressed: provider.resetPassword,
                                loading: provider.loading,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
