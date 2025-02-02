import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/models/organization_model/org.dart';
import 'package:suvidhaorg/providers/theme_provider.dart';
import 'package:suvidhaorg/screens/organization_screens/request_organization_verification.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';
import 'package:suvidhaorg/widgets/loading_screen.dart';
import 'package:suvidhaorg/widgets/snackbar.dart';
import 'dart:io';

import '../../models/organization_model/coordinates.dart';
import '../../models/organization_model/new_org.dart';
import '../../providers/location_provider.dart';
import '../../services/backend_service.dart';

class AddOrganizationProvider extends ChangeNotifier {
  final BuildContext context;
  late LocationProvider locationProvider;
  AddOrganizationProvider(this.context) {
    initialize();
  }

  void initialize() {
    backendService = Provider.of<BackendService>(context);
    locationProvider = Provider.of<LocationProvider>(context);
    org = NewOrganization(
      nameOrg: '',
      intro: '',
      address: locationProvider.currentAddress ?? '',
      longLat: LongitudeLatitudeModel(type: 'Point', coordinates: [
        locationProvider.currentPosition?.latitude != null
            ? locationProvider.currentPosition!.longitude
            : 0.0,
        locationProvider.currentPosition?.latitude != null
            ? locationProvider.currentPosition!.longitude
            : 0.0
      ]),
      contactPerson: '',
      contactNumber: '',
      panNo: '',
      citzImg: [],
      orgImg: [],
      panImg: [],
    );
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

  NewOrganization? org;

  // Function to add PAN image
  Future<void> addPanImage() async {
    try {
      final response = await backendService.postImage(image: panImg!);

      if (response.statusCode == 200 && response.result != null) {
        panImageError = null;

        org!.panImg.add(response.result!);
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
        org!.orgImg.add(response.result!);
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
        org!.citzImg?.add(response.result!);
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
          org!.panImg.isEmpty ||
          org!.orgImg.isEmpty) {
        loading = false;
        orgImageError = 'Please select an image to upload';
        panImageError = 'Please select an image to upload';
        notifyListeners();
        return;
      }

      final response = await backendService.createOrganization(newOrg: org!);

      if (response.statusCode == 200 && response.result != null) {
        loading = false;
        organizationModel = OrganizationModel.fromJson(response.result!);
        RequestOrganizationVerification.show(context, organizationModel!.id);
        notifyListeners();
      } else {
        loading = false;
        notifyListeners();
        context.pop();
        SnackBarHelper.showSnackbar(
          context: context,
          errorMessage: response.errorMessage,
        );
      }
    } catch (e) {
      debugPrint("Error in creating an organization");
      loading = false;
      SnackBarHelper.showSnackbar(
        context: context,
        errorMessage: 'Something went wrong, please try again later.',
      );
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
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: AppBar(
              title: Text(
                'Get Started with Your Organization',
                maxLines: 2,
                textAlign: TextAlign.left,
              ),
              centerTitle: false,
              automaticallyImplyLeading: true,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              child: SingleChildScrollView(
                child: provider.locationProvider.currentPosition == null
                    ? Column(
                        children: [
                          provider.loading
                              ? Center(
                                  child: LoadingScreen(),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.35,
                                      ),
                                      Icon(
                                        Icons.location_disabled,
                                        size: 70,
                                      ),
                                      Text(
                                        "Please enable location services to continue.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CustomButton(
                                        label: "Enable now",
                                        onPressed: () => provider
                                            .locationProvider
                                            .getCurrentLocation(),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Let's get your organization started by filling out the details below.",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            "Basic Organization Details",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(
                            height: 10,
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
                                    // Organization Name Field
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Organization Name',
                                        hintText: 'Enter the organization name',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) =>
                                          provider.org!.nameOrg = value,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the organization name';
                                        }
                                        if (!RegExp(r'[a-zA-Z]')
                                            .hasMatch(value)) {
                                          return 'Organization name should contain at least one alphabet';
                                        }
                                        //org name should be 5 characters long
                                        if (value.length < 5) {
                                          return 'Organization name should be at least 5 characters long';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    // Address Field
                                    TextFormField(
                                      initialValue: provider.locationProvider
                                              .currentAddress ??
                                          '',
                                      decoration: InputDecoration(
                                        labelText: 'Organization Address',
                                        hintText:
                                            'Enter the organization address',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) =>
                                          provider.org!.address = value,
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

                                    // Contact Person Field
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Contact Person',
                                        hintText: 'Name of the contact person',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) =>
                                          provider.org!.contactPerson = value,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the contact person\'s name';
                                        }
                                        if (!RegExp(r'[a-zA-Z]')
                                            .hasMatch(value)) {
                                          return 'Contact person\'s name should contain at least one alphabet';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    // Contact Number Field
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Contact Number',
                                        hintText: 'Enter the contact number',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 16,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        suffixIcon: Icon(Icons.phone),
                                      ),
                                      maxLength: 10,
                                      onChanged: (value) =>
                                          provider.org!.contactNumber = value,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the contact number';
                                        }
                                        if (!RegExp(r'^\d{10}$')
                                            .hasMatch(value)) {
                                          return 'Please enter a valid contact number';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.phone,
                                    ),
                                    const SizedBox(height: 5),
                                    // PAN Number Field
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'PAN Number',
                                        hintText: 'Enter PAN number',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 16,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) =>
                                          provider.org!.panNo = value,
                                      maxLength: 20,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the PAN number';
                                        }

                                        if (!RegExp(r'^[0-9\-_]{5,20}$')
                                            .hasMatch(value)) {
                                          return 'Please enter a valid PAN number';
                                        }

                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 5),

                                    // Brief Introduction Field
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Brief Introduction',
                                        hintText:
                                            'Enter a brief introduction to the organization',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) =>
                                          provider.org!.intro = value,
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

                                    // Message Field (Optional)
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Message',
                                        hintText:
                                            'Message for the admin (optional)',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) =>
                                          provider.org!.message = value,
                                      keyboardType: TextInputType.multiline,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Image Containers with error message
                          _imageContainer(
                            context,
                            imageUrls: provider.org!.panImg,
                            label: 'PAN Card Photo',
                            onTap: () => provider.pickImage('pan'),
                            errorMessage: provider.panImageError,
                          ),
                          const SizedBox(height: 20),
                          _imageContainer(
                            context,
                            imageUrls: provider.org!.orgImg,
                            label: 'Organization Photo',
                            onTap: () => provider.pickImage('orgimage'),
                            errorMessage: provider.orgImageError,
                          ),
                          const SizedBox(height: 20),
                          _imageContainer(
                            context,
                            imageUrls: provider.org!.citzImg,
                            label: 'Citizenship Photo',
                            onTap: () => provider.pickImage('citizen'),
                            errorMessage: provider.citizenImageError,
                          ),
                          const SizedBox(height: 30),

                          // Submit Button
                          CustomButton(
                            label: 'Add Organization',
                            onPressed: () => provider.addOrganization(),
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

  // Image Container with error message
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
