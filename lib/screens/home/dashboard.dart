import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/organization_provider.dart';
import '../../widgets/custom_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final organizationProvider = Provider.of<OrganizationProvider>(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: organizationProvider.organization != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            FontAwesomeIcons.buildingCircleExclamation,
                            size: 100,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No organization found!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                          'Create your organization today and unlock all the features.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 30),
                      CustomButton(
                        label: 'Create One Now',
                        onPressed: () => context.push('/add_organization'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
