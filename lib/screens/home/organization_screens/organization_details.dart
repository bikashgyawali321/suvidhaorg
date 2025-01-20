import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:suvidhaorg/extensions/date.dart';
import 'package:suvidhaorg/models/organization_model/org.dart';

class OrganizationDetailsScreen extends StatelessWidget {
  final OrganizationModel organizationModel;

  OrganizationDetailsScreen({super.key, required this.organizationModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Organization Profile',
          maxLines: 2,
        ),
        elevation: 4,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Organization Name',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        organizationModel.nameOrg,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Introduction',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        organizationModel.intro,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Address',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        organizationModel.address,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    //active status
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Active Status',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        organizationModel.isActive == true
                            ? 'Active'
                            : 'Inactive',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Contact Person',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        organizationModel.contactPerson,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Contact Number',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        organizationModel.contactNumber,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    //org slug
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Organization Slug',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        organizationModel.slug,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Rating',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        organizationModel.rating != null
                            ? '${organizationModel.rating} / 5'
                            : 'Not Rated Yet',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),

                    // Organization Status
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Verification Status',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        organizationModel.status!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),

                    // Organization block status
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Block Status',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        organizationModel.isBlocked == true
                            ? 'Blocked'
                            : 'Not Blocked',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),

                    //organization created at
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Created At',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        organizationModel.createdAt.toLocal().toVerbalDateTime,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),

                    //organization updated at
                    customDivider(),
                    ListTile(
                      title: Text(
                        'Updated At',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        organizationModel.updatedAt.toLocal().toVerbalDateTime,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Organization Image Section Label
            Text(
              organizationModel.orgImg.length > 1
                  ? 'Organization Images'
                  : 'Organization Image',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),

            if (organizationModel.orgImg.isNotEmpty)
              Column(
                spacing: 5,
                children: organizationModel.orgImg.map((imgUrl) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Stack(
                          children: [
                            BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10,
                                sigmaY: 10,
                              ),
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    imgUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.broken_image,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imgUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            else
              Container(
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  'No Image Available',
                ),
              ),
            const SizedBox(height: 20),

            // Citizenship Image Section Label
            Text(
              organizationModel.citzImg.length > 1
                  ? 'Citizenship Images'
                  : 'Citizenship Image',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),

            // Citizenship Image Section in Card using Map
            if (organizationModel.citzImg.isNotEmpty)
              Column(
                spacing: 5,
                children: organizationModel.citzImg.map((imgUrl) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Stack(
                          children: [
                            BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10,
                                sigmaY: 10,
                              ),
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    imgUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.broken_image,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imgUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            else
              Container(
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  'No Citizenship Image Available',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            const SizedBox(height: 20),

            // PAN Image Section Label
            Text(
              organizationModel.panImg.length > 1 ? 'PAN Images' : 'PAN Image',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),

            // PAN Image Section in Card using Map
            if (organizationModel.panImg.isNotEmpty)
              Column(
                spacing: 5,
                children: organizationModel.panImg.map((imgUrl) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Stack(
                          children: [
                            BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10,
                                sigmaY: 10,
                              ),
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    imgUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.broken_image,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imgUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            else
              Container(
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  'No PAN Image Available',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // create a divider widget
  Widget customDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        thickness: 0,
        color: Colors.blueGrey[400],
      ),
    );
  }
}
