import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suvidhaorg/models/service_model/service_array_response.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(
                "Here are the services offered to users by your organization.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButton(
                label: 'Add More Services',
                onPressed: () => context.push(
                  '/service_names',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
