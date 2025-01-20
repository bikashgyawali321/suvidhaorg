import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/widgets/form_bottom_sheet_header.dart';

import '../../../providers/organization_provider.dart';
import '../../../widgets/custom_button.dart';

class RequestOrganizationVerification extends StatelessWidget {
  RequestOrganizationVerification({super.key, required this.organizationId});
  String? organizationId;

  static void show(BuildContext context, String organizationId) {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          RequestOrganizationVerification(organizationId: organizationId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrganizationProvider>(context);
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormBottomSheetHeader(title: 'Request Organization Verification'),
          const SizedBox(height: 15),
          Text(
            'Your organization is not verified yet. Please request for verification.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () => context.pop(),
                  label: 'Not Now',
                  backgroundColor: Colors.red,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  onPressed: () =>
                      orgProvider.sendVerificationRequest(organizationId!),
                  label: 'Request',
                  backgroundColor: Colors.blueAccent,
                  loading: orgProvider.loading,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }
}
