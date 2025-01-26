import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/models/service_model/service_array_response.dart';
import 'package:suvidhaorg/screens/home/service_screens/service_names_screen.dart';

class OfferedServicesScreen extends StatelessWidget {
  OfferedServicesScreen({super.key, required this.services});
  List<DocsService> services;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offered Services'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => ServiceNamesProvider(context),
        builder: (context, child) => Consumer<ServiceNamesProvider>(
          builder: (context, provider, child) {
            if (provider.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (provider.serviceNames.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                      'There aren\'t any services offered yet.Please register a service to get started.'),
                ),
              );
            } else {
              return SingleChildScrollView(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Here are the services we offer, feel free to pick whatever works best for you!",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customDivider(),
                            SizedBox(
                              height: 10,
                            ),
                            for (final service in services) ...[
                              ListTile(
                                title: Text(service.serviceName.name),
                                subtitle: Text(service.serviceName.name),
                                trailing: Icon(Icons.chevron_right),
                                onTap: () {
                                  context.go('/service_details',
                                      extra: service);
                                },
                              ),
                              customDivider(),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
              // children: [
              //   for (final service in services) ...[
              //     ListTile(
              //       title: Text(service.serviceName.name),
              //       onTap: () {
              //         context.go('/service_details', extra: service);
              //       },
              //     ),
              //     Divider(),
              //   ] //TODO: give some description text , see service name screen for demo

              //   //TODO: map each service to a listtile inside a , mathi deko service tyo yeha aauxa aafai  , see service name screen for demo
              //   //ontap listtile ma gayera service details screen ma janu parxa, create it and add a goroute to it in main.dart, each listtile tap garda teha jana paro
              // ],
            }
          },
        ),
      ),
    );
  }

  Widget customDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        thickness: 0,
        color: Colors.blueGrey[400],
      ),
    );
  }
}
