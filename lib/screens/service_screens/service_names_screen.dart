import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/models/service_model/service_name.dart';
import 'package:suvidhaorg/services/backend_service.dart';

class ServiceNamesProvider extends ChangeNotifier {
  final BuildContext context;
  late BackendService _backendService;
  ServiceNamesProvider(this.context) {
    initialize();
  }

  bool loading = false;
  List<ServiceNameModel> serviceNames = [];

  void initialize() {
    _backendService = Provider.of<BackendService>(context);
    fetchServiceNames();
  }

  Future<void> fetchServiceNames() async {
    loading = true;
    notifyListeners();

    final response = await _backendService.getAllServiceNames();

    if (response.result != null &&
        response.statusCode == 200 &&
        response.errorMessage == null) {
      for (final service in response.result) {
        serviceNames.add(ServiceNameModel.fromJson(service));
      }
    } else {
      serviceNames = [];
    }

    loading = false;
    notifyListeners();
  }
}

class ServiceNameScreen extends StatelessWidget {
  const ServiceNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a Service Category'),
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
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Looks like there is no service category available.Please contact the administrator for more details.',
                  ),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Let’s start by selecting the type of service you want to register.",
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
                            horizontal: 10,
                            vertical: 15,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Offered Categories',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              for (final serviceName
                                  in provider.serviceNames) ...[
                                ListTile(
                                  title: Text(serviceName.name),
                                  subtitle:
                                      Text('Code: ${serviceName.serviceCode}'),
                                  trailing: Icon(Icons.chevron_right),
                                  onTap: () => context.push(
                                    '/add_service/${serviceName.id}',
                                  ),
                                ),
                                customDivider(),
                                SizedBox(
                                  height: 5,
                                ),
                              ]
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
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
