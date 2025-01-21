import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/models/organization_model/coordinates.dart';
import 'package:suvidhaorg/models/organization_model/org.dart';
import 'package:suvidhaorg/providers/organization_provider.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';
import 'package:suvidhaorg/widgets/custom_button_sheet.dart';
import 'package:suvidhaorg/widgets/snackbar.dart';

import '../../../models/organization_model/new_org.dart';
import '../../../services/backend_service.dart';

class UpdateOrganizationProvider extends ChangeNotifier {
  final BuildContext context;
  OrganizationModel? orgModel;
  UpdateOrganizationProvider(this.context, this.orgModel) {
    initialize();
  }

  late BackendService backendService;
  bool loading = false;
  File? panImg;
  File? orgImg;
  File? citzImg;
  String? imageType;
  final _formKey = GlobalKey<FormState>();
  String? panImageError;
  String? orgImageError;
  String? citizenImageError;
  late OrganizationProvider _organizationProvider;

  NewOrganization? org;

  void initialize() {
    backendService = Provider.of<BackendService>(context);
    _organizationProvider = Provider.of<OrganizationProvider>(context);
    getCurrentLocation();
    org = NewOrganization(
      nameOrg: orgModel?.nameOrg ?? '',
      intro: orgModel?.intro ?? '',
      address: orgModel?.address ?? '',
      longLat: orgModel?.longLat ??
          LongitudeLatitudeModel(type: 'Point', coordinates: [0.0, 0.0]),
      panImg: orgModel?.panImg ?? [],
      orgImg: orgModel?.orgImg ?? [],
      citzImg: orgModel?.citzImg ?? [],
      contactNumber: orgModel?.contactNumber ?? '',
      contactPerson: orgModel?.contactPerson ?? '',
      panNo: orgModel?.panNo ?? '',
      message: orgModel?.message ?? '',
    );
  }

  // Function to get the current user location
  Future<void> getCurrentLocation() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      org!.longLat = LongitudeLatitudeModel(
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

        org?.panImg.add(response.result!);
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
        org?.orgImg.add(response.result!);
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
        org?.citzImg?.add(response.result!);
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

  //function to delete image
  void deleteImage(String imageUrl, String imageType) async {
    final response = await backendService.deleteImage(imageUrl: imageUrl);
    if (response.statusCode == 200 && response.errorMessage == null) {
      imageType == 'Pan'
          ? org!.panImg.remove(imageUrl)
          : imageType == 'Org'
              ? org!.orgImg.remove(imageUrl)
              : org!.citzImg?.remove(imageUrl);
    } else {
      SnackBarHelper.showSnackbar(
        context: context,
        errorMessage: response.errorMessage,
      );
    }
  }

  //function to add organization
  Future<void> updateOrganization() async {
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

      final response = await backendService.updateOrg(organization: org!);

      if (response.statusCode == 200 && response.result != null) {
        loading = false;
        orgModel = OrganizationModel.fromJson(response.result!);
        SnackBarHelper.showSnackbar(
          context: context,
          successMessage: response.message,
        );
        context.go('/home');
        notifyListeners();
      } else {
        loading = false;
        notifyListeners();

        SnackBarHelper.showSnackbar(
          context: context,
          errorMessage: response.errorMessage,
        );
      }
    } catch (e) {
      debugPrint("Error in updating  organization");
      loading = false;
      SnackBarHelper.showSnackbar(
        context: context,
        errorMessage: 'Something went wrong, please try again later.',
      );
      notifyListeners();
    } finally {
      _organizationProvider.getOrganizationDetails();
      notifyListeners();
    }
  }
}

class UpdateOrganizationScreen extends StatelessWidget {
  final OrganizationModel organization;

  const UpdateOrganizationScreen({super.key, required this.organization});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UpdateOrganizationProvider(context, organization),
      builder: (context, child) => Consumer<UpdateOrganizationProvider>(
        builder: (context, provider, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: AppBar(
              title: Text(
                'Update Organization Details',
                maxLines: 2,
                textAlign: TextAlign.left,
              ),
              centerTitle: false,
              automaticallyImplyLeading: true,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Update the details for your organization.",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "Basic Organization Details",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 10),
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
                                initialValue: provider.org?.nameOrg,
                                decoration: InputDecoration(
                                  labelText: 'Organization Name',
                                  hintText: 'Enter the organization name',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (value) =>
                                    provider.org!.nameOrg = value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the organization name';
                                  }
                                  if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                                    return 'Organization name should contain at least one alphabet';
                                  }
                                  if (value.length < 5) {
                                    return 'Organization name should be at least 5 characters long';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),

                              // Address Field
                              TextFormField(
                                initialValue: provider.org?.address,
                                decoration: InputDecoration(
                                  labelText: 'Organization Address',
                                  hintText: 'Enter the organization address',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (value) =>
                                    provider.org?.address = value,
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
                              SizedBox(height: 16),
                              // Contact Person Field
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Contact Person',
                                  hintText: 'Name of the contact person',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                initialValue: provider.org?.contactPerson,
                                onChanged: (value) =>
                                    provider.org?.contactPerson = value,
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
                              SizedBox(height: 16),
                              // Contact Number Field
                              TextFormField(
                                initialValue: provider.org?.contactNumber,
                                decoration: InputDecoration(
                                  labelText: 'Contact Number',
                                  hintText: 'Enter the contact number',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: Icon(Icons.phone),
                                ),
                                maxLength: 10,
                                onChanged: (value) =>
                                    provider.org?.contactNumber = value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the contact number';
                                  }
                                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                    return 'Please enter a valid contact number';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                              ),
                              SizedBox(height: 8),
                              // PAN Number Field
                              TextFormField(
                                initialValue: provider.org?.panNo,
                                decoration: InputDecoration(
                                  labelText: 'PAN Number',
                                  hintText: 'Enter PAN number',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) =>
                                    provider.org?.panNo = value,
                                maxLength: 10,
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
                              SizedBox(height: 8),
                              // Brief Introduction Field
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Brief Introduction',
                                  hintText:
                                      'Enter a brief introduction to the organization',
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                initialValue: provider.org?.intro,
                                onChanged: (value) =>
                                    provider.org?.intro = value,
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
                              SizedBox(height: 16),
                              // Message Field (Optional)
                              TextFormField(
                                initialValue: provider.org?.message,
                                decoration: InputDecoration(
                                  labelText: 'Message',
                                  hintText: 'Message for the admin (optional)',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (value) =>
                                    provider.org?.message = value,
                                keyboardType: TextInputType.multiline,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Image Containers with error message and options to add more or delete
                    _imageContainer(context,
                        imageUrls: provider.org?.panImg,
                        label: 'PAN Card Photo',
                        onTap: () => provider.pickImage('pan'),
                        errorMessage: provider.panImageError,
                        onDelete: (imageUrl) =>
                            provider.deleteImage(imageUrl, 'Pan'),
                        loading: provider.loading),
                    const SizedBox(height: 20),
                    _imageContainer(
                      context,
                      imageUrls: provider.org?.orgImg,
                      label: 'Organization Photo',
                      onTap: () => provider.pickImage('orgimage'),
                      errorMessage: provider.orgImageError,
                      onDelete: (imageUrl) =>
                          provider.deleteImage(imageUrl, 'orgimage'),
                      loading: provider.loading,
                    ),
                    const SizedBox(height: 20),
                    _imageContainer(
                      context,
                      imageUrls: provider.org?.citzImg,
                      label: 'Citizenship Photo',
                      onTap: () => provider.pickImage('citizen'),
                      errorMessage: provider.citizenImageError,
                      onDelete: (imageUrl) =>
                          provider.deleteImage(imageUrl, 'citizen'),
                      loading: provider.loading,
                    ),
                    const SizedBox(height: 30),

                    // Submit Button
                    CustomButton(
                      label: 'Update Organization',
                      onPressed: () => provider.updateOrganization(),
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
    required Function(String imageUrl) onDelete,
    bool loading = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label for the section
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        if (imageUrls == null || imageUrls.isEmpty) ...[
          // Add Image Card
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
                        color: Colors.grey[700],
                        size: 40,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Add Image',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
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
            children: imageUrls.map((imageUrl) {
              return GestureDetector(
                onLongPress: () => CustomButtonSheet.show(
                  context: context,
                  title: 'Delete Image',
                  message: 'Are you sure you want to delete this image?',
                  positiveLabel: 'Cancel',
                  negativeLabel: 'Delete',
                  onTap: () => onDelete(imageUrl),
                  loading: loading,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Image display
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
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          // Add More button
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.27,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Card(
              child: TextButton.icon(
                onPressed: onTap,
                icon: Icon(
                  Icons.add_a_photo_outlined,
                  size: 18,
                ),
                label: Text(
                  'Add More',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
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
