import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';
import 'package:suvidhaorg/widgets/form_bottom_sheet_header.dart';

class VerificationBottomSheet extends StatelessWidget {
  VerificationBottomSheet({
    super.key,
    required this.positiveLabel,
    required this.negativeLabel,
    required this.onTap,
    required this.title,
    this.message,
    this.loading,
  });
  final String positiveLabel;
  final String negativeLabel;
  final VoidCallback onTap;
  final String title;
  final String? message;
  bool? loading;
  static void show({
    required BuildContext context,
    required String title,
    required String positiveLabel,
    required String negativeLabel,
    required VoidCallback onTap,
    bool loading = false,
    String? message,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => VerificationBottomSheet(
        title: title,
        positiveLabel: positiveLabel,
        negativeLabel: negativeLabel,
        onTap: onTap,
        message: message,
        loading: loading,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FormBottomSheetHeader(title: title),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              if (message != null)
                Text(
                  message!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      label: negativeLabel,
                      onPressed: () => context.pop(),
                      loading: loading!,
                      backgroundColor: Colors.red,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomButton(
                      label: positiveLabel,
                      onPressed: onTap,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
