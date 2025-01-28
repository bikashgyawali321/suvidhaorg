import 'package:flutter/material.dart';
import 'package:suvidhaorg/extensions/extensions.dart';
import 'package:suvidhaorg/models/service_model/service_array_response.dart';

class ServiceDetailsScreen extends StatelessWidget {
  ServiceDetailsScreen({super.key, required this.service});
  final DocsService service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All the details of the service you offer!!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 8,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Service Name',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        service.serviceName.name.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Description',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        service.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Price',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        service.price.toCurrency,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Status',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        service.status,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      trailing: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          service.img[0],
                        ),
                      ),
                      title: Text(
                        'Service Provider Name',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(service.serviceProviderName,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Service Provider Phone',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        service.serviceProviderPhone,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Service Provider Email',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        service.serviceProviderEmail,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
