import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSnackbar({
    required BuildContext context,
    String? successMessage,
    String? errorMessage,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          successMessage ?? errorMessage ?? 'Something went wrong',
        ),
        backgroundColor: successMessage != null ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
