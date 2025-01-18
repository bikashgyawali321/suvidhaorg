import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/providers/theme_provider.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';
import 'package:suvidhaorg/widgets/form_bottom_sheet_header.dart';
import 'dart:io';

import '../../models/image_models/image_model.dart';
import '../../models/organization_model/coordinates.dart';
import '../../models/organization_model/new_org.dart';
import '../../services/backend_service.dart';

class AddOrganizationProvider extends ChangeNotifier {
  final BuildContext context;
  AddOrganizationProvider(this.context) {
    backendService = Provider.of<BackendService>(context);
    getCurrentLocation();
  }

  late BackendService backendService;
  bool loading = false;
  File? panImg;
  File? orgImg;
  File? citzImg;
  String? imageType;
  final _formKey = GlobalKey<FormState>();

  NewOrganization org = NewOrganization(
    nameOrg: '',
    intro: '',
    address: '',
    longLat: LongitudeLatitudeModel(type: 'Point', coordinates: [0, 0]),
    contactPerson: '',
    contactNumber: '',
    panNo: '',
    citzImg: '',
    orgImg: '',
    panImg: '',
  );

  // Function to get the current user location
  Future<void> getCurrentLocation() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      org.longLat = LongitudeLatitudeModel(
        type: 'point',
        coordinates: [position.longitude, position.latitude],
      );
      notifyListeners();
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Location permission denied, please grant the permission for creating an organization.'),
          duration: const Duration(seconds: 5),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // Function to add PAN image
  Future<void> addPanImage() async {
    try {
      if (panImg == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image to upload')),
        );
        return;
      }

      final response = await backendService.postImage(image: panImg!);

      if (response.statusCode == 200 && response.data != null) {
        // ImageModel imageModel = ImageModel.fromJson(response.data!);
        // org.panImg = imageModel.url!;
        print(response.data);
        org.panImg = response.data!;
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong, please try again later."),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      notifyListeners();
      debugPrint("Error uploading PAN image: ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  // Function to add Organization image
  Future<void> addOrgImage() async {
    try {
      if (orgImg == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image to upload')),
        );
        return;
      }

      final response = await backendService.postImage(image: orgImg!);

      if (response.statusCode == 200 && response.data != null) {
        org.orgImg = response.data!;
        await Future.delayed(const Duration(seconds: 2));
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong, please try again later."),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      notifyListeners();
      debugPrint("Error uploading Organization image: ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  // Function to add Citizenship image
  Future<void> addCitzImage() async {
    try {
      if (citzImg == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image to upload')),
        );
        return;
      }

      final response = await backendService.postImage(image: citzImg!);

      if (response.statusCode == 200 && response.data != null) {
        org.citzImg = response.data!;
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error uploading Citizenship  image: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong, please try again later."),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } finally {
      notifyListeners();
    }
  }

  Future<void> pickImage(String imageType) async {
    try {
      final ImagePicker picker = ImagePicker();
      final source = await _showImageSourceDialog();

      if (source != null) {
        final pickedFile = await picker.pickImage(
          source: source,
        );

        if (pickedFile != null) {
          File selectedImage = File(pickedFile.path);

          if (imageType == 'pan') {
            panImg = selectedImage;
            notifyListeners();
          } else if (imageType == 'orgimage') {
            orgImg = selectedImage;
            notifyListeners();
          } else if (imageType == 'citizen') {
            citzImg = selectedImage;
            notifyListeners();
          }

          if (imageType == 'pan') {
            await addPanImage();
            notifyListeners();
          } else if (imageType == 'orgimage') {
            await addOrgImage();
            notifyListeners();
          } else if (imageType == 'citizen') {
            await addCitzImage();
            notifyListeners();
          }
        }
      }
    } catch (e) {
      debugPrint("Error picking image: ${e.toString()}");
    }
  }

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

  //function to add organization

  Future<void> addOrganization() async {
    try {
      loading = true;
      notifyListeners();

      if (!_formKey.currentState!.validate()) {
        loading = false;
        notifyListeners();
        return;
      }

      final response = await backendService.createOrganization(newOrg: org);

      if (response.statusCode == 200 && response.data != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error in creating an organization");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong, please try again later."),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      notifyListeners();
    }
  }
}

class AddOrganizationScreen extends StatelessWidget {
  const AddOrganizationScreen({super.key});
  //bottom sheet
  static void show(BuildContext context) {
    showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      context: context,
      builder: (context) => const AddOrganizationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddOrganizationProvider(context),
      builder: (context, child) => Consumer<AddOrganizationProvider>(
        builder: (context, provider, child) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  const FormBottomSheetHeader(title: 'Add Organization'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: provider._formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          Text(
                            'Create an organization by filling the following fields',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),

                          // Organization Name
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Organization Name'),
                              hintText: 'Enter the organization name',
                            ),
                            onChanged: (value) => provider.org.nameOrg = value,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the organization name';
                              }
                              if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                                return 'Organization name should contain at least one alphabet';
                              }
                              return null;
                            },
                          ),

                          // Address
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Organization Address'),
                              hintText: 'Enter the organization address',
                            ),
                            onChanged: (value) => provider.org.address = value,
                            keyboardType: TextInputType.streetAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the address of the organization';
                              }
                              if (!RegExp(r"^[a-zA-Z0-9\s,.'-]{3,}$")
                                  .hasMatch(value)) {
                                return 'Please enter a valid address';
                              }
                              return null;
                            },
                          ),

                          // Contact Person
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Contact Person'),
                              hintText: 'Name of the contact person',
                            ),
                            onChanged: (value) =>
                                provider.org.contactPerson = value,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the contact person\'s name';
                              }
                              if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                                return 'Contact person\'s name should contain at least one alphabet';
                              }
                              return null;
                            },
                          ),

                          //contact number
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Contact Number'),
                              hintText:
                                  'Enter the contact number of the organization',
                            ),
                            onChanged: (value) =>
                                provider.org.contactNumber = value,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the contact number';
                              }
                              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                return 'Please enter a valid contact number';
                              }
                              return null;
                            },
                          ),

                          // PAN Number
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text('PAN Number'),
                              hintText: ' Enter PAN number',
                            ),
                            onChanged: (value) => provider.org.panNo = value,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the PAN number';
                              }
                              if (!RegExp(r'^\d{5,20}$').hasMatch(value)) {
                                return 'Please enter a valid PAN number';
                              }
                              return null;
                            },
                          ),

                          // Image Containers

                          // a brief message for the organization
                          TextFormField(
                            decoration: InputDecoration(
                                label: Text('Message'),
                                hintText: 'message for admin (optional)'),
                            onChanged: (v) => provider.org.message = v,
                            keyboardType: TextInputType.multiline,
                          ),
                          //brief introduction to organization

                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Brief Introduction'),
                              hintText:
                                  'Enter a brief introduction to the organization',
                            ),
                            onChanged: (value) => provider.org.intro = value,
                            keyboardType: TextInputType.multiline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a brief introduction to the organization';
                              }

                              return null;
                            },
                          ),

                          _imageContainer(
                            context,
                            imageUrl: provider.org.panImg,
                            label: 'PAN Card Photo',
                            onTap: () => provider.pickImage('pan'),
                          ),
                          _imageContainer(
                            context,
                            imageUrl: provider.org.orgImg,
                            label: 'Organization Photo',
                            onTap: () => provider.pickImage('orgimage'),
                          ),
                          _imageContainer(
                            context,
                            imageUrl: provider.org.citzImg,
                            label: 'Citizenship Photo',
                            onTap: () => provider.pickImage('citizen'),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          // Submit Button
                          CustomButton(
                            label: 'Add Organization',
                            onPressed: provider.addOrganization,
                            loading: provider.loading,
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
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
    required String? imageUrl,
    required String label,
    required VoidCallback onTap,
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
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(12),
              image: imageUrl != null && imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null || imageUrl.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_library,
                          color: primaryIconColor,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add Image',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: primaryIconColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
