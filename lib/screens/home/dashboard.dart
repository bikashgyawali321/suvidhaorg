import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/screens/home.dart';

import '../../providers/organization_provider.dart';
import '../../widgets/custom_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final organizationProvider = context.watch<OrganizationProvider>();
    final IndexProvider indexProvider = context.watch<IndexProvider>();
    return SafeArea(
      child: SingleChildScrollView(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => organizationProvider.getOrganizationData(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: organizationProvider.loading == true
                  ? Column(
                      spacing: 2,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                        ),
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                        Text('Loading'),
                      ],
                    )
                  : organizationProvider.organization != null &&
                          organizationProvider.services.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 120,
                                    child: GestureDetector(
                                      onTap: () => context.push(
                                        '/service_list',
                                        extra: organizationProvider.services,
                                      ),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Text(
                                                'Total Services Offered',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              // SizedBox(
                                              //   height: 5,
                                              // ),
                                              Text(
                                                organizationProvider
                                                    .totalServices
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (organizationProvider.requestedOrders >
                                    0) ...[
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 120,
                                      child: GestureDetector(
                                        onTap: () => context.push(
                                          '/orders_on_status',
                                          extra: 'Requested',
                                        ),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Text(
                                                  'Requested Orders',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                // SizedBox(
                                                //   height: 5,
                                                // ),
                                                Text(
                                                  organizationProvider
                                                      .requestedOrders
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => indexProvider.changeIndex(2),
                                    child: Card(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Total Orders',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              organizationProvider.totalOrders
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => context.push(
                                      '/orders_on_status',
                                      extra: 'Accepted',
                                    ),
                                    child: Card(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Active Orders',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              organizationProvider
                                                  .acceptedOrders
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => context.push(
                                      '/orders_on_status',
                                      extra: 'Completed',
                                    ),
                                    child: Card(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Completed Orders',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              organizationProvider
                                                  .completedOrders
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => indexProvider.changeIndex(0),
                                    child: Card(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Total Bookings',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              organizationProvider.totalBookings
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => context.push(
                                      '/bookings_on_status',
                                      extra: 'Pending',
                                    ),
                                    child: Card(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Pending Bookings',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              organizationProvider
                                                  .pendingBookings
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => context.push(
                                      '/bookings_on_status',
                                      extra: 'Accepted',
                                    ),
                                    child: Card(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Accepted Bookings',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              organizationProvider
                                                  .acceptedBookings
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => context.push(
                                      '/bookings_on_status',
                                      extra: 'Completed',
                                    ),
                                    child: Card(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Completed Bookings',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              organizationProvider
                                                  .completedBookings
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => context.push(
                                      '/bookings_on_status',
                                      extra: 'Rejected',
                                    ),
                                    child: Card(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Rejected Bookings',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              organizationProvider
                                                  .rejectedBookings
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 100,
                            ),
                          ],
                        )
                      : organizationProvider.organization != null &&
                              organizationProvider.services.isEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                ),
                                Center(
                                  child: Icon(
                                    Icons.hourglass_empty,
                                    size: 70,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'No services found!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Looks like you have not created a service yet available to the users, create one now.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                CustomButton(
                                  label: 'Create one now',
                                  onPressed: () =>
                                      context.push('/service_names'),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                ),
                                Card(
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons
                                          .buildingCircleExclamation,
                                      size: 100,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'No organization found!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Create your organization today and unlock all the features.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 30),
                                CustomButton(
                                  label: 'Create One Now',
                                  onPressed: () =>
                                      context.push('/add_organization'),
                                ),
                              ],
                            ),
            ),
          ),
        ),
      ),
    );
  }
}
