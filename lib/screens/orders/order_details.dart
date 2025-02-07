import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/providers/organization_provider.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';
import 'package:suvidhaorg/widgets/form_bottom_sheet_header.dart';
import 'package:suvidhaorg/widgets/loading_screen.dart';
import 'package:suvidhaorg/widgets/snackbar.dart';

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
    await Future.delayed(const Duration(seconds: 2));

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
              child: provider.loading
                  ? LoadingScreen()
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Here are the details of the order',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                                      provider.order?.serviceName.name ??
                                          'Not Available',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
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
                                      provider.order?.status ??
                                          'Not Determined',
                                    ),
                                  ),
                                  customDivider(),
                                  ListTile(
                                    title: Text(
                                      'Customer Name',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    subtitle: Text(
                                      provider.order?.user.name ??
                                          'Not Available',
                                    ),
                                    trailing: provider.order?.user.profilePic !=
                                            null
                                        ? CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                              provider.order?.user.profilePic ??
                                                  '',
                                            ),
                                          )
                                        : null,
                                  ),
                                  customDivider(),
                                  ListTile(
                                    title: Text(
                                      'Customer Email',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    subtitle: Text(
                                      provider.order?.user.email ??
                                          'Not Available',
                                    ),
                                  ),
                                  customDivider(),
                                  ListTile(
                                    title: Text(
                                      'Customer Phone',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    subtitle: Text(
                                      provider.order?.user.phoneNumber ??
                                          'Not Available',
                                    ),
                                  ),
                                  customDivider(),
                                  ListTile(
                                    title: Text(
                                      'Address',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    subtitle: Text(
                                      provider.order?.location ??
                                          'Not Available',
                                    ),
                                  ),
                                  customDivider(),
                                  if (provider.order?.service != null) ...[
                                    ListTile(
                                      title: Text(
                                        'Service Provider Name',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      subtitle: Text(
                                        provider.order?.service!
                                                .serviceProviderName ??
                                            'Not Available',
                                      ),
                                      trailing: provider.order != null &&
                                              provider.order!.service!.img
                                                  .isNotEmpty
                                          ? CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(
                                                provider
                                                    .order!.service!.img.first,
                                              ),
                                            )
                                          : null,
                                    ),
                                    customDivider(),
                                    ListTile(
                                      title: Text(
                                        'Service Provider Phone',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      subtitle: Text(
                                        provider.order?.service!
                                                .serviceProviderPhone ??
                                            'Not Available',
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: provider.order?.status == "Requested"
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          label: 'Reject Order',
                                          backgroundColor: Colors.deepOrange,
                                          onPressed: () {
                                            context.pop();
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: CustomButton(
                                          label: 'Accept Order',
                                          disabled: provider.loading == true
                                              ? true
                                              : false,
                                          onPressed: () {
                                            AcceptOrderBottomSheet.show(
                                              context: context,
                                              orderId: orderId,
                                              provider: provider,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : provider.order?.status == "Accepted"
                                    ? CustomButton(
                                        label: 'Mark as Completed',
                                        disabled: provider.loading == true
                                            ? true
                                            : false,
                                        onPressed: () {
                                          MarkOrderAsCompletedBottomSheet.show(
                                            context: context,
                                            orderId: provider.orderId,
                                            provider: provider,
                                          );
                                        },
                                      )
                                    : null,
                          ),
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

class AcceptOrderProvider extends ChangeNotifier {
  final BuildContext context;
  final String orderId;
  bool loading = false;
  late BackendService _backendService;
  late OrganizationProvider organizationProvider;
  final OrderDetailProvider provider;

  AcceptOrderProvider(this.context, this.orderId, this.provider) {
    initialize();
  }

  void initialize() {
    _backendService = Provider.of<BackendService>(context, listen: false);
    organizationProvider =
        Provider.of<OrganizationProvider>(context, listen: false);
  }

  Future<void> acceptOrder() async {
    loading = true;
    notifyListeners();
    final response = await _backendService.acceptOrder(oid: orderId);
    if (response.result != null &&
        response.statusCode == 200 &&
        response.errorMessage == null) {
      SnackBarHelper.showSnackbar(
        context: context,
        successMessage: response.message,
      );
      provider.fetchOrderDetails();
      context.pop();
      loading = false;
      notifyListeners();
    } else {
      SnackBarHelper.showSnackbar(
        context: context,
        errorMessage: response.errorMessage,
      );
      loading = false;
      notifyListeners();
    }
  }
}

class AcceptOrderBottomSheet extends StatelessWidget {
  AcceptOrderBottomSheet(
      {super.key, required this.orderId, required this.provider});
  OrderDetailProvider provider;
  final String orderId;
  static void show({
    required BuildContext context,
    required String orderId,
    required OrderDetailProvider provider,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AcceptOrderBottomSheet(
        orderId: orderId,
        provider: provider,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AcceptOrderProvider(context, orderId, provider),
      builder: (context, child) => Consumer<AcceptOrderProvider>(
        builder: (context, value, child) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBottomSheetHeader(
              title: 'Accept Order',
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to accept this order?',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'Cancel',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          backgroundColor: Colors.redAccent,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomButton(
                          label: 'Accept',
                          onPressed: value.acceptOrder,
                          loading: value.loading,
                          disabled: value.loading == true ? true : false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarkOrderAsCompletedProvider extends ChangeNotifier {
  final BuildContext context;
  final String orderId;
  final OrderDetailProvider provider;
  bool loading = false;
  late BackendService _backendService;
  late OrganizationProvider organizationProvider;

  MarkOrderAsCompletedProvider(this.context, this.orderId, this.provider) {
    initialize();
  }

  void initialize() {
    _backendService = Provider.of<BackendService>(context, listen: false);
    organizationProvider =
        Provider.of<OrganizationProvider>(context, listen: false);
  }

  Future<void> markOrderAsCompleted() async {
    loading = true;
    notifyListeners();
    final response = await _backendService.completeOrder(oid: orderId);
    if (response.result != null &&
        response.statusCode == 200 &&
        response.errorMessage == null) {
      provider.fetchOrderDetails();
      SnackBarHelper.showSnackbar(
        context: context,
        successMessage: response.message,
      );
      context.pop();
      loading = false;
      notifyListeners();
    } else {
      context.pop();
      SnackBarHelper.showSnackbar(
        context: context,
        errorMessage: response.errorMessage,
      );
      loading = false;
      notifyListeners();
    }
  }
}

class MarkOrderAsCompletedBottomSheet extends StatelessWidget {
  MarkOrderAsCompletedBottomSheet(
      {super.key, required this.orderId, required this.provider});
  final String orderId;
  final OrderDetailProvider provider;
  static void show({
    required BuildContext context,
    required String orderId,
    required OrderDetailProvider provider,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          MarkOrderAsCompletedBottomSheet(orderId: orderId, provider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MarkOrderAsCompletedProvider(context, orderId, provider),
      builder: (context, child) => Consumer<MarkOrderAsCompletedProvider>(
        builder: (context, value, child) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBottomSheetHeader(
              title: 'Mark Order as Completed',
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to mark this order as completed?',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'Cancel',
                          onPressed: () {
                            context.pop();
                          },
                          backgroundColor: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomButton(
                          label: 'Yes',
                          onPressed: value.markOrderAsCompleted,
                          loading: value.loading,
                          disabled: value.loading == true ? true : false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
