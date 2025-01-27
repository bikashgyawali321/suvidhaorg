import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSnackbar({
    required BuildContext context,
    String? successMessage,
    String? errorMessage,
    String? warningMessage,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          successMessage ??
              errorMessage ??
              warningMessage ??
              'Something went wrong',
        ),
        backgroundColor: successMessage != null
            ? Colors.green
            : errorMessage != null
                ? Colors.red
                : Colors.deepOrange,
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
