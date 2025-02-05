import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/models/pagination/list_model.dart';
import 'package:suvidhaorg/providers/organization_provider.dart';
import 'package:suvidhaorg/providers/theme_provider.dart';
import 'package:suvidhaorg/widgets/loading_screen.dart';

import '../../models/order_models/order_array_response.dart';
import '../../services/backend_service.dart';

class OrderOnStatusProvider extends ChangeNotifier {
  List<DocsOrder> orders = [];
  bool loading = false;
  bool hasMore = true;
  bool loadingMore = false;
  String searchTerm = '';
  final String orderStatus;
  final BuildContext context;
  late BackendService _backendService;
  late OrganizationProvider organizationProvider;

  ListingSchema? listingSchema;

  OrderOnStatusProvider(this.context, {required this.orderStatus}) {
    initialize();
  }

  void initialize() {
    _backendService = Provider.of<BackendService>(context, listen: false);
    organizationProvider =
        Provider.of<OrganizationProvider>(context, listen: false);
    listingSchema = ListingSchema(
      limit: 50,
      page: 1,
      status: orderStatus,
    );
    fetchOrders();
  }

  Future<void> fetchOrders({bool reset = false}) async {
    if (reset) {
      listingSchema!.page = 1;
      orders.clear();
      hasMore = true;
      notifyListeners();
    }

    if (loading || !hasMore) return;

    loading = true;
    notifyListeners();
    if (organizationProvider.organization == null) {
      loading = false;
      notifyListeners();
      return;
    }
    final response =
        await _backendService.getAlOrders(listingSchema: listingSchema!);

    if (response.result != null &&
        response.statusCode == 200 &&
        response.errorMessage == null) {
      OrderArrayResponse orderArrayResponse =
          OrderArrayResponse.fromJson(response.result);
      List<DocsOrder> fetchedOrders =
          orderArrayResponse.docs.isNotEmpty ? orderArrayResponse.docs : [];

      if (fetchedOrders.isEmpty ||
          fetchedOrders.length < listingSchema!.limit) {
        hasMore = false;
      }

      orders.addAll(fetchedOrders);
    } else {
      hasMore = false;
    }

    loading = false;
    notifyListeners();
  }

  void fetchMoreOrders() async {
    if (loadingMore || !hasMore) return;

    loadingMore = true;
    listingSchema!.page += 1;
    notifyListeners();

    await fetchOrders();

    loadingMore = false;
    notifyListeners();
  }

  void updateSearchTerm(String term) {
    searchTerm = term;
    notifyListeners();
  }
}

class OrdersOnStatusScreen extends StatelessWidget {
  const OrdersOnStatusScreen({super.key, required this.status});
  final String status;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderOnStatusProvider(context, orderStatus: status),
      builder: (context, child) {
        return Consumer<OrderOnStatusProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('$status Orders'),
                centerTitle: false,
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    if (provider.loading)
                      const Center(child: LoadingScreen())
                    else if (provider.orders.isEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 80,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No ${status.toLowerCase()} orders found!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'Looks like there are no ${status.toLowerCase()} orders available.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )
                    else
                      NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent &&
                              provider.hasMore) {
                            provider.fetchMoreOrders();
                          }
                          return false;
                        },
                        child: RefreshIndicator(
                          onRefresh: () => provider.fetchOrders(
                            reset: true,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Column(
                              children: [
                                Divider(
                                  height: 0,
                                  thickness: 0,
                                ),
                                for (final order in provider.orders) ...[
                                  Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            order.user.name.toColor,
                                        child: Text(
                                          order.user.name[0],
                                        ),
                                      ),
                                      title: Text(order.serviceName.name),
                                      subtitle: Text(
                                        order.user.name,
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('View Details',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium),
                                          Icon(Icons.chevron_right),
                                        ],
                                      ),
                                      onTap: () {
                                        context.push(
                                          '/order/${order.id}',
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: -2,
                      left: 00,
                      right: 0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        color: Theme.of(context).appBarTheme.foregroundColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (value) =>
                                provider.updateSearchTerm(value),
                            decoration: const InputDecoration(
                              hintText: 'Search orders...',
                              prefixIcon: Icon(
                                Icons.search,
                                size: 30,
                              ),
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
