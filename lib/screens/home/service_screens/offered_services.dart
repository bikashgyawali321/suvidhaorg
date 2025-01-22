import 'package:flutter/material.dart';
import 'package:suvidhaorg/models/service_model/service_array_response.dart';

class OfferedServicesScreen extends StatelessWidget {
  OfferedServicesScreen({super.key, required this.services});
  List<DocsService> services;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //TODO: give some title to the screen , ali ramro offered services bhanda , app ko mathi dekhini lai we say appbar
        title: const Text(''),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            //TODO: give some description text , see service name screen for demo

            //TODO: map each service to a listtile inside a , mathi deko service tyo yeha aauxa aafai  , see service name screen for demo
            //ontap listtile ma gayera service details screen ma janu parxa, create it and add a goroute to it in main.dart, each listtile tap garda teha jana paro

            //on onTap of the listtile, use this context.push('/service_details',extra:service as DocsService) to navigate to the service details screen
          ],
        ),
      ),
    );
  }
}
