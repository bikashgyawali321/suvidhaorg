import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {

  final BuildContext context;
  OrderProvider(this.context);
  bool loading=false;
  
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
