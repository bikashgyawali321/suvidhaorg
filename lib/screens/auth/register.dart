import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidha/models/auth_models/register_request.dart';
import 'package:suvidha/providers/theme_provider.dart';
import 'package:suvidha/services/backend_service.dart';
import 'package:suvidha/widgets/custom_button.dart';

class RegisterProvider extends ChangeNotifier {
  final BuildContext context;
  RegisterProvider({required this.context})
      : backendService = Provider.of<BackendService>(context);
  bool loading = false;
  num otp = 0;

  late BackendService backendService;
  RegisterRequest request = RegisterRequest(
    email: '',
    name: '',
    password: '',
    phoneNumber: '',
  );
  bool obsecureText = true;
  final _formKey = GlobalKey<FormState>();
  final PageController controller = PageController(initialPage: 0);
  //method to toggle visibility of password
  void toggleVisibility() {
    obsecureText = !obsecureText;
    notifyListeners();
  }

  //method to register user
  Future<void> registerUser() async {
    loading = true;
    notifyListeners();

    if (!_formKey.currentState!.validate()) {
      loading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await backendService.registerUser(request);

      if (response.statusCode == 200) {
        loading = false;

        if (controller.page == 0) {
          await controller.animateToPage(
            1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error in registering User: ${e.toString()}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    loading = false;
    notifyListeners();
  }

  //method to verify the email
  Future<void> verifyEmail() async {
    loading = true;
    notifyListeners();
    try {
      final response =
          await backendService.verifyEmail(email: request.email, otp: otp);
      if (response.statusCode == 200) {
        loading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/login');
        notifyListeners();
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
    } catch (e) {
      debugPrint("Error while verifying email :${e.toString()}");
    }
  }

  //method to resend the verification email

  Future<void> resendVerificationEmail() async {
    try {
      final response =
          await backendService.resendVerificationEmail(email: request.email);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error while verifying email :${e.toString()}");
    }
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterProvider(context: context),
      builder: (context, child) => Consumer<RegisterProvider>(
        builder: (context, provider, child) => Scaffold(
          backgroundColor: primaryDark,
          body: SafeArea(
            child: Form(
              key: provider._formKey,
              child: PageView.builder(
                itemCount: 2,
                controller: provider.controller,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'logo',
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/icon/app_icon.png',
                                  height: 200,
                                ),
                                Text(
                                  'सुविधा',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(color: suvidhaWhite),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Card(
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Text(
                                    "Create an account",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  const SizedBox(height: 25),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Full Name'),
                                    onChanged: (value) =>
                                        provider.request.name = value,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Full Name is required';
                                      }
                                      if (!RegExp(r'^[a-zA-Z ]+$')
                                          .hasMatch(value)) {
                                        return 'Full Name can only contain alphabets and spaces';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Email'),
                                    onChanged: (value) =>
                                        provider.request.email = value,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email is required';
                                      }
                                      if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value)) {
                                        return 'Enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Phone Number'),
                                    maxLength: 10,
                                    onChanged: (value) =>
                                        provider.request.phoneNumber = value,
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Phone Number is required';
                                      }
                                      if (!RegExp(r'^[0-9]{10}$')
                                          .hasMatch(value)) {
                                        return 'Enter a valid phone number';
                                      }
                                      if (value.length != 10) {
                                        return 'Phone number should be of 10 digits';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      suffixIcon: IconButton(
                                        icon: Icon(provider.obsecureText
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () =>
                                            provider.toggleVisibility(),
                                      ),
                                    ),
                                    obscureText: provider.obsecureText,
                                    onChanged: (value) =>
                                        provider.request.password = value,
                                    validator: (value) {
                                      RegExp passwordRegex = RegExp(
                                          r'^(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{6,})');
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (!passwordRegex.hasMatch(value)) {
                                        return 'Password must be 7+ characters with a letter, number,\nand symbol.';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Confirm Password',
                                        suffixIcon: IconButton(
                                            onPressed: () =>
                                                provider.toggleVisibility(),
                                            icon: Icon(provider.obsecureText
                                                ? Icons.visibility_off
                                                : Icons.visibility))),
                                    obscureText: provider.obsecureText,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != provider.request.password) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (value) =>
                                        provider.registerUser,
                                  ),
                                  const SizedBox(height: 20),
                                  CustomButton(
                                    label: 'Register',
                                    onPressed: provider.registerUser,
                                    loading: provider.loading,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text(
                                        'Already have an account? Login'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: Hero(
                            tag: 'logo',
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    'assets/icon/app_icon.png',
                                    height: 230,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'सुविधा',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(color: suvidhaWhite),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text('Verify your email',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                                SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  'A 6 digit verification code has been sent to your email address. Please enter the code below to verify your email address.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color: Colors.deepOrange,
                                          fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.justify,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Verification Code',
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  onChanged: (value) =>
                                      provider.otp = num.parse(value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Verification code is required';
                                    }
                                    if (value.length != 6) {
                                      return 'Verification code should be of 6 digits';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                CustomButton(
                                  label: 'Verify',
                                  onPressed: provider.verifyEmail,
                                  loading: false,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Didn\'t receive the code?'),
                                    TextButton(
                                      onPressed:
                                          provider.resendVerificationEmail,
                                      child: Text('Resend request'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
