import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
    Provider.of<OrganizationProvider>(context, listen: false)
        .getOrganizationDetails();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
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
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: suvidhaWhite,
                                  ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          authProvider.user?.email ?? 'N/A',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
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
              // child: CustomScrollView(
              //   physics: AlwaysScrollableScrollPhysics(),
              //   slivers: [
              //     SliverToBoxAdapter(
              //       child: Text(
              //         'Who are you looking for?',
              //         style: Theme.of(context).textTheme.titleLarge,
              //       ),
              //     ),
              //     SliverToBoxAdapter(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           SizedBox(
              //             height: 5,
              //           ),
              //           Text(
              //             'Choose a service to get started.',
              //             style: Theme.of(context).textTheme.bodyLarge,
              //           ),
              //           SizedBox(
              //             height: 10,
              //           )
              //         ],
              //       ),
              //     ),
              //     SliverGrid.builder(
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //           crossAxisCount: 2, childAspectRatio: 2.4),
              //       itemCount: offeredServiceList.offeredService.length,
              //       itemBuilder: (_, index) {
              //         final service = offeredServiceList.offeredService[index];
              //         return GestureDetector(
              //           // onTap: () {
              //           //   context.push('/service/${service.name}');
              //           // },
              //           child: Card(
              //             color: Color.lerp(
              //               Theme.of(context).colorScheme.surfaceContainer,
              //               service.name.toColor,
              //               0.7,
              //             ),
              //             child: Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Row(
              //                 children: [
              //                   ClipOval(
              //                     child: Image.asset(
              //                       service.imageUrl,
              //                       height: 56,
              //                     ),
              //                   ),
              //                   SizedBox(width: 10),
              //                   Text(
              //                     service.name,
              //                     style: Theme.of(context).textTheme.bodyLarge,
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     )
              //   ],
              // ),
              child: Column(children: [
                CustomButton(
                  label: 'Add organization',
                  onPressed: () => context.push('/add_organization'),
                )
              ])),
        ));
  }
}
