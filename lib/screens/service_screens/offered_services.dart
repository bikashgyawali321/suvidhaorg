import 'package:flutter/material.dart';
import 'package:suvidhaorg/models/service_model/service_array_response.dart';

class OfferedServicesScreen extends StatelessWidget {
  OfferedServicesScreen({super.key, required this.services});
  List<DocsService> services;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: const [],
        ),
      ),
    );
  }
}
