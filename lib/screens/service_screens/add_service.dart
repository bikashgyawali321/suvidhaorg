import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/models/service_model/new_service.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';
import 'package:suvidhaorg/widgets/snackbar.dart';
import 'package:suvidhaorg/widgets/verification_botttom_sheet.dart';

import '../../models/service_model/service.dart';
import '../../providers/organization_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/backend_service.dart';

class AddServiceProvider extends ChangeNotifier {
  final BuildContext context;
  late BackendService backendService;
  final String serviceNameId;
  late OrganizationProvider organizationProvider;

  AddServiceProvider(this.context, this.serviceNameId) {
    initialize();
  }

  void initialize() {
    backendService = Provider.of<BackendService>(context);
    organizationProvider = Provider.of<OrganizationProvider>(context);
    newServiceModel = NewServiceModel(
      service: serviceNameId,
      serviceProviderName: '',
      serviceProviderEmail: '',
      serviceProviderPhone: '',
      description: '',
      price: 0,
      img: [],
    );
  }

  String? errorMessage;
  ServiceModel? serviceModel;
  NewServiceModel? newServiceModel;
  File? serviceProviderImage;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  //add image
  Future<void> addImage() async {
    if (serviceProviderImage == null) return;
    final response =
        await backendService.postImage(image: serviceProviderImage!);
    if (response.result != null && response.statusCode == 200) {
      newServiceModel?.img?.add(response.result!);
      SnackBarHelper.showSnackbar(
        context: context,
        successMessage: response.message,
      );
      notifyListeners();
    } else {
      errorMessage = response.errorMessage ??
          'Something went wrong, please try again later';
      SnackBarHelper.showSnackbar(
        context: context,
        errorMessage: response.errorMessage,
      );
    }
  }

  //add service
  Future<void> addService() async {
    if (!_formKey.currentState!.validate()) return;
    loading == true;
    notifyListeners();

    final response = await backendService.addService(service: newServiceModel!);

    if (response.result != null && response.statusCode == 200) {
      serviceModel = ServiceModel.fromJson(response.result!);

      loading = false;
      notifyListeners();
      await VerificationBottomSheet.show(
        context: context,
        title: "Request Service Verification",
        positiveLabel: "Request Now",
        negativeLabel: "Not Now",
        onTap: requestVerification,
        loading: loading,
        message:
            'Your service has been added successfully, request for verification now!',
      );
      await organizationProvider.getAllOrganizationServices();
    } else {
      SnackBarHelper.showSnackbar(
        context: context,
        errorMessage: response.errorMessage,
      );
    }
  }

  // show image picker dialog box
  Future<ImageSource?> _showImageSourceDialog() async {
    return showDialog<ImageSource>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Choose an image source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text("Camera"),
                onTap: () => Navigator.pop(context, ImageSource.camera),
                leading: Icon(Icons.camera_alt),
              ),
              ListTile(
                title: Text("Gallery"),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
                leading: Icon(Icons.photo_library_rounded),
              ),
            ],
          ),
        );
      },
    );
  }

  //pick image
  Future<void> pickImage() async {
    final source = await _showImageSourceDialog();
    if (source == null) return;
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;
    serviceProviderImage = File(pickedFile.path);
    addImage();
  }

  //request for service verification
  Future<void> requestVerification() async {
    if (serviceModel == null) return;
    loading = true;
    notifyListeners();

    final response = await backendService.requestServiceVerification(
        serviceId: serviceModel!.id);
    if (response.result != null && response.statusCode == 200) {
      serviceModel = ServiceModel.fromJson(response.result!);
      context.go('/home');
      SnackBarHelper.showSnackbar(
        context: context,
        successMessage: response.message,
      );
      loading = false;
      notifyListeners();
    } else {
      SnackBarHelper.showSnackbar(
        context: context,
        errorMessage: response.errorMessage,
      );
    }
  }
}

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({super.key, required this.serviceNameId});
  final String serviceNameId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddServiceProvider(context, serviceNameId),
      builder: (context, child) => Consumer<AddServiceProvider>(
        builder: (context, provider, child) => Scaffold(
          appBar: AppBar(
            title: Text('Offer a Service'),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 7,
                children: [
                  Text(
                    "Provide additional details about the service to expand your organization's offerings!",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Basic Details:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Form(
                        key: provider._formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Service Provider Name',
                                hintText:
                                    "Name of the person who provide the service",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) => provider
                                  .newServiceModel?.serviceProviderName = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter service provider name';
                                }
                                if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                                  return 'Service provider name should contain only alphabets';
                                }
                                if (value.length < 5) {
                                  return 'Service provider name should be atleast 5 characters long';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Service Provider Email',
                                hintText:
                                    "Email of the person who provide the service",
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) => provider.newServiceModel
                                  ?.serviceProviderEmail = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter service provider email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.phone),
                                labelText: 'Phone Number',
                                hintText:
                                    "Phone number of the person who provide the service",
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) => provider.newServiceModel
                                  ?.serviceProviderPhone = value,
                              maxLength: 10,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter service provider phone number';
                                }
                                if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            //description
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Description',
                                hintText: "Description of the service",
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) =>
                                  provider.newServiceModel?.description = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter service description';
                                }
                                if (value.length < 20) {
                                  return 'Service description should be atleast 20 characters long';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              expands: false,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Price',
                                hintText: "Price of the service",
                                prefix: Text('Rs.'),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) => provider
                                  .newServiceModel?.price = double.parse(value),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter service price';
                                }
                                if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                                  return 'Please enter a valid price';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Service Image:',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _imageContainer(
                    context,
                    imageUrls: provider.newServiceModel!.img,
                    label: 'Service Provider Photo',
                    onTap: provider.pickImage,
                    errorMessage: provider.errorMessage,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    label: 'Add service',
                    onPressed: provider.addService,
                    loading: provider.loading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageContainer(
    BuildContext context, {
    required List<String>? imageUrls,
    required String label,
    required VoidCallback onTap,
    required String? errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        if (imageUrls == null || imageUrls.isEmpty) ...[
          GestureDetector(
            onTap: onTap,
            child: Card(
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library,
                        color: primaryIconColor,
                        size: 40,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Add Image',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: primaryIconColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ] else ...[
          Column(
            spacing: 5,
            children: imageUrls.map((imageUrl) {
              return Card(
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Card(
            color: primaryIconColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextButton(
                onPressed: onTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Add more',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                )),
          ),
        ],
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
      ],
    );
  }
}
