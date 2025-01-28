import 'package:flutter/material.dart';
import 'package:suvidhaorg/extensions/extensions.dart';

import '../../models/bookings/booking_model.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({
    super.key,
    required this.booking,
  });
  final DocsBooking booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Details',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  trailing: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      booking.user.profilePic?.isNotEmpty == true
                          ? booking.user.profilePic![0]
                          : '',
                    ),
                  ),
                  title: Text(
                    'User Name',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(booking.user.userName,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                customDivider(),
                ListTile(
                  title: Text(
                    'User Phone',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(
                    booking.user.userPhoneNumber,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                customDivider(),
                ListTile(
                  title: Text(
                    'Service Name',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(booking.user.userName,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                customDivider(),
                ListTile(
                  trailing: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      booking.service.images?.isNotEmpty == true
                          ? booking.service.images![0]
                          : '',
                    ),
                  ),
                  title: Text(
                    'Service Provider Name',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(
                    booking.service.serviceProviderName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                customDivider(),
                ListTile(
                  title: Text(
                    'Service Provider Phone',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(
                    booking.service.serviceProviderPhoneNumber,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                customDivider(),
                ListTile(
                  title: Text(
                    'Service Provider Email',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(
                    booking.service.serviceProviderEmail,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                customDivider(),
                ListTile(
                  title: Text(
                    'Service Price',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(
                    booking.totalPrice.toCurrency,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                customDivider(),
                ListTile(
                  title: Text(
                    'Booking Status',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(
                    booking.bookingStatus,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
