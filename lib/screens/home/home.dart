import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/models/offered_service.dart';
import 'package:suvidhaorg/providers/organization_provider.dart';
import 'package:suvidhaorg/providers/theme_provider.dart';
import 'package:suvidhaorg/screens/home/profile_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';

import '../../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OfferedServiceList offeredServiceList = OfferedServiceList();

  @override
  void initState() {
    super.initState();
    // Fetch organization details
    Provider.of<OrganizationProvider>(context, listen: false)
        .getOrganizationDetails();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final organizationProvider = Provider.of<OrganizationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'सुविधा सेवा',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: primaryDark,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: suvidhaWhite,
                      child: Icon(
                        Icons.business,
                        size: 50,
                        color: primaryIconColor,
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Text(
                        authProvider.user?.name ?? 'N/A',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: suvidhaWhite,
                            ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Text(
                        authProvider.user?.email ?? 'N/A',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: suvidhaWhite,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const ProfileContent(),
            ],
          ),
        ),
      ),
      body: SafeArea(
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
    );
  }
}
