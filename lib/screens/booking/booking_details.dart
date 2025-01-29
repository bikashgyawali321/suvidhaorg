import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suvidhaorg/extensions/extensions.dart';
import 'package:suvidhaorg/screens/booking/change_booking_status.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';

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
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      trailing: booking.user.profilePic != null
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                booking.user.profilePic!,
                              ),
                            )
                          : SizedBox(),
                      title: Text(
                        'User Name',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        booking.user.userName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        'User Phone Number',
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
                      subtitle: Text(
                        booking.user.userName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      trailing: booking.service.images!.isNotEmpty
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                booking.service.images![0],
                              ),
                            )
                          : null,
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
            SizedBox(
              height: 20,
            ),
            if (booking.bookingStatus == 'Pending') ...[
              CustomButton(
                label: 'Change Booking Status',
                onPressed: () {
                  ChangeBookingStatusBottomSheet.show(
                    context: context,
                    bid: booking.id,
                  );
                },
              )
            ],
            if (booking.bookingStatus == 'Accepted') ...[
              CustomButton(
                label: 'Mark as Completed',
                onPressed: () {
                  ChangeBookingStatusBottomSheet.show(
                    context: context,
                    bid: booking.id,
                    isCompletedBooking: true,
                  );
                },
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget customDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        thickness: 0,
        height: 0,
      ),
    );
  }
}
