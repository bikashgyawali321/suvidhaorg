import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';
import 'package:suvidhaorg/widgets/form_bottom_sheet_header.dart';

class AlertBottomSheet extends StatelessWidget {
  AlertBottomSheet({
    super.key,
    required this.positiveLabel,
    required this.negativeLabel,
    required this.onTap,
    required this.title,
    required this.onNegativeTap,
    this.message,
    this.loading,
  });
  final String positiveLabel;
  final String negativeLabel;
  final VoidCallback? onTap;
  final VoidCallback onNegativeTap;
  final String title;
  final String? message;
  bool? loading;
  static void show({
    required BuildContext context,
    required String title,
    required String positiveLabel,
    required String negativeLabel,
    required VoidCallback onPositiveTap,
    required VoidCallback onNegativeTap,
    bool loading = false,
    String? message,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AlertBottomSheet(
        title: title,
        positiveLabel: positiveLabel,
        negativeLabel: negativeLabel,
        onTap: onPositiveTap,
        message: message,
        loading: loading,
        onNegativeTap: onNegativeTap,
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
                      label: positiveLabel,
                      onPressed: () => onTap ?? context.pop(),
                      loading: loading!,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomButton(
                      label: negativeLabel,
                      onPressed: onNegativeTap,
                      loading: loading!,
                      backgroundColor: Colors.red,
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
