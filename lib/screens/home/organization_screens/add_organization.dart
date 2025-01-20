import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/models/organization_model/org.dart';
import 'package:suvidhaorg/providers/theme_provider.dart';
import 'package:suvidhaorg/screens/home/organization_screens/request_organization_verification.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';
import 'package:suvidhaorg/widgets/form_bottom_sheet_header.dart';
import 'dart:io';

import '../../../models/organization_model/coordinates.dart';
import '../../../models/organization_model/new_org.dart';
import '../../../services/backend_service.dart';

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
  OrganizationModel? organizationModel;
  String? panImageError;
  String? orgImageError;
  String? citizenImageError;

  NewOrganization org = NewOrganization(
    nameOrg: '',
    intro: '',
    address: '',
    longLat: LongitudeLatitudeModel(type: 'Point', coordinates: [0, 0]),
    contactPerson: '',
    contactNumber: '',
    panNo: '',
    citzImg: [],
    orgImg: [],
    panImg: [],
  );

  // Function to get the current user location
  Future<void> getCurrentLocation() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      org.longLat = LongitudeLatitudeModel(
        type: 'Point',
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
      final response = await backendService.postImage(image: panImg!);

      if (response.statusCode == 200 && response.result != null) {
        panImageError = null;

        org.panImg.add(response.result!);
        notifyListeners();
      } else {
        panImageError = response.message;
        notifyListeners();
      }
    } catch (e) {
      panImageError = 'Something went wrong, please try again later.';
      notifyListeners();
      debugPrint("Error uploading PAN image: ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  // Function to add Organization image
  Future<void> addOrgImage() async {
    try {
      final response = await backendService.postImage(image: orgImg!);

      if (response.statusCode == 200 && response.result != null) {
        orgImageError = null;
        org.orgImg.add(response.result!);
        await Future.delayed(const Duration(seconds: 2));
        notifyListeners();
      } else {
        orgImageError = response.message;
        notifyListeners();
      }
    } catch (e) {
      orgImageError = 'Something went wrong, please try again later.';
      notifyListeners();
      debugPrint("Error uploading Organization image: ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  // Function to add Citizenship image
  Future<void> addCitzImage() async {
    try {
      final response = await backendService.postImage(image: citzImg!);

      if (response.statusCode == 200 && response.result != null) {
        citizenImageError = null;
        org.citzImg?.add(response.result!);
        notifyListeners();
      } else {
        citizenImageError = response.message;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error uploading Citizenship  image: ${e.toString()}");
      citizenImageError = 'Something went wrong, please try again later.';
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

      if (!_formKey.currentState!.validate() ||
          org.panImg.isEmpty ||
          org.orgImg.isEmpty) {
        loading = false;
        orgImageError = 'Please select an image to upload';
        panImageError = 'Please select an image to upload';
        notifyListeners();
        return;
      }

      final response = await backendService.createOrganization(newOrg: org);

      if (response.statusCode == 200 && response.result != null) {
        loading = false;
        organizationModel = OrganizationModel.fromJson(response.result!);
        RequestOrganizationVerification.show(context, organizationModel!.id);
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error in creating an organization");
      loading = false;
      context.pop();
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddOrganizationProvider(context),
      builder: (context, child) => Consumer<AddOrganizationProvider>(
        builder: (context, provider, child) => Scaffold(
          appBar: AppBar(
            title: Flexible(
              child: Text(
                'Get Started with Your Organization',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: suvidhaWhite,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's get your organization started by filling out the details below.",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 20),

                    // Organization Name
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Organization Name',
                        hintText: 'Enter the organization name',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => provider.org.nameOrg = value,
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
                    const SizedBox(height: 16),

                    // Address
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Organization Address',
                        hintText: 'Enter the organization address',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => provider.org.address = value,
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
                    const SizedBox(height: 16),

                    // Contact Person
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Contact Person',
                        hintText: 'Name of the contact person',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => provider.org.contactPerson = value,
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
                    const SizedBox(height: 16),

                    // Contact Number
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        hintText: 'Enter the contact number',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => provider.org.contactNumber = value,
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
                    const SizedBox(height: 16),

                    // PAN Number
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'PAN Number',
                        hintText: 'Enter PAN number',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => provider.org.panNo = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the PAN number';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Please enter a valid PAN number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Brief Introduction
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Brief Introduction',
                        hintText:
                            'Enter a brief introduction to the organization',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => provider.org.intro = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a brief introduction to the organization';
                        }
                        if (value.length < 10) {
                          return 'Introduction should be at least 10 characters long';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 16),

                    // Message (Optional)
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Message',
                        hintText: 'Message for the admin (optional)',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      onChanged: (value) => provider.org.message = value,
                      keyboardType: TextInputType.multiline,
                    ),

                    const SizedBox(height: 20),

                    // Image Containers
                    _imageContainer(
                      context,
                      imageUrls: provider.org.panImg,
                      label: 'PAN Card Photo',
                      onTap: () => provider.pickImage('pan'),
                      errorMessage: provider.panImageError,
                    ),
                    const SizedBox(height: 20),
                    _imageContainer(
                      context,
                      imageUrls: provider.org.orgImg,
                      label: 'Organization Photo',
                      onTap: () => provider.pickImage('orgimage'),
                      errorMessage: provider.orgImageError,
                    ),
                    const SizedBox(height: 20),
                    _imageContainer(
                      context,
                      imageUrls: provider.org.citzImg,
                      label: 'Citizenship Photo',
                      onTap: () => provider.pickImage('citizen'),
                      errorMessage: provider.citizenImageError,
                    ),
                    const SizedBox(height: 30),

                    // Submit Button

                    CustomButton(
                      label: 'Add Organization',
                      onPressed: provider.addOrganization,
                      loading: provider.loading,
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
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
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
        ] else ...[
          Column(
            children: imageUrls.map((imageUrl) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.blue[700],
            ),
            child: TextButton(
                onPressed: onTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.add_a_photo_outlined,
                        color: suvidhaWhite, size: 25),
                    const SizedBox(width: 5),
                    Text(
                      'Add image',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: suvidhaWhite,
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
