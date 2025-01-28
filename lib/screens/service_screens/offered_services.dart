import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suvidhaorg/models/service_model/service_array_response.dart';

class OfferedServicesScreen extends StatelessWidget {
  OfferedServicesScreen({super.key, required this.services});
  List<DocsService> services;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offered Services'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Here are the services you offer!!",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      for (final service in services) ...[
                        ListTile(
                          title: Text(service.serviceName.name),
                          subtitle: Text("Tap to view details"),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            context.push('/service_details', extra: service);
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
        ),
      ),
    );
  }

  Widget customDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        thickness: 0,
        height: 0,
      ),
    );
  }
}
