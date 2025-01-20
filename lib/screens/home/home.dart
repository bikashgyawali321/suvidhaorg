import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart'; // Import the lottie package
import 'package:suvidhaorg/models/offered_service.dart';
import 'package:suvidhaorg/providers/organization_provider.dart';
import 'package:suvidhaorg/providers/theme_provider.dart';
import 'package:suvidhaorg/screens/home/profile_content.dart';
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
    bool isOrganizationAvailable = organizationProvider.organization != null;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: suvidhaWhite),
        backgroundColor: primaryDark,
        title: Text(
          'सुविधा सेवा',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: suvidhaWhite,
              ),
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
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: Text(
                        authProvider.user?.name ?? 'N/A',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: suvidhaWhite,
                            ),
                      ),
                    ),
                    Flexible(
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: isOrganizationAvailable
              ? Column(
                  children: [
                    CustomButton(
                      label: 'Add organization',
                      onPressed: () => context.push('/add_organization'),
                    )
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'No organization found! Create one now.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        label: 'Create Organization',
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
