import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order_models/order_array_response.dart';
import '../../services/backend_service.dart';

class OrderDetailProvider extends ChangeNotifier {
  DocsOrder? order;
  bool loading = false;
  final BuildContext context;
  final String orderId;
  late BackendService _backendService;

  OrderDetailProvider(this.context, this.orderId) {
    initialize();
  }

  void initialize() {
    _backendService = Provider.of<BackendService>(context, listen: false);
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    loading = true;
    notifyListeners();
    final response = await _backendService.getOrderById(oid: orderId);
    if (response.result != null &&
        response.statusCode == 200 &&
        response.errorMessage == null) {
      order = DocsOrder.fromJson(response.result);
      loading = false;
      notifyListeners();
    } else {
      loading = false;
      notifyListeners();
    }
  }
}

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  final String orderId;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderDetailProvider(context, orderId),
      builder: (context, child) => Consumer<OrderDetailProvider>(
        builder: (context, provider, child) => Scaffold(
          appBar: AppBar(
            title: Text("Order Details"),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Here are the details of the order',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                'Service Name',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              subtitle: Text(
                                provider.order?.serviceName.first.name
                                        .toUpperCase() ??
                                    '',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            customDivider(),
                            ListTile(
                              title: Text(
                                'Status',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              subtitle: Text(
                                provider.order?.status ?? 'Not Determined',
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 6,
    );
  }
}
