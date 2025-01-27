import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/extensions/date.dart';
import 'package:suvidhaorg/models/bookings/booking_model.dart';
import 'package:suvidhaorg/models/pagination/list_model.dart';

import '../../services/backend_service.dart';

class BookingProvider extends ChangeNotifier {
  List<DocsBooking> bookings = [];
  List<DocsBooking> activeBookings = [];
  bool loading = false;
  final BuildContext context;
  late BackendService _backendService;
  BookingProvider(this.context) {
    initialize();
  }

  void initialize() {
    _backendService = Provider.of<BackendService>(context);
    fetchBookings();
  }

  ListingSchema listingSchema = ListingSchema(
    page: 0,
    limit: 20,
  );
  Future<void> fetchBookings() async {
    loading = true;
    notifyListeners();

    final response = await _backendService.getAllBookings(
        // listingSchema: listingSchema,
        );

    if (response.result != null &&
        response.statusCode == 200 &&
        response.errorMessage == null) {
      BookingArrayResponse bookingArrayResponse =
          BookingArrayResponse.fromJson(response.result);
      bookings = bookingArrayResponse.docs;
      activeBookings = bookings.where((element) {
        return element.bookingStatus == 'Pending' &&
            element.bookingStatus == 'Accepted';
      }).toList();
    } else {
      bookings = [];
    }

    loading = false;
    notifyListeners();
  }
}

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingProvider(context),
      builder: (context, child) => Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.activeBookings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      size: 60,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Looks like you have no active bookings at the moment!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: provider.activeBookings.length,
              itemBuilder: (context, index) {
                final booking = provider.bookings[index];
                if (booking.bookingStatus == 'Pending') {
                  return Card(
                    child: Column(
                      children: [
                        Text('Pending Bookings'),
                        ListTile(
                          title: Text(booking.serviceName.name),
                          trailing: Text(
                            booking.bookingDate.toVerbalDateTime,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Card(
                    child: Column(
                      children: [
                        Text('Ongoing Bookings'),
                        ListTile(
                          title: Text(booking.serviceName.name),
                          trailing: Text(
                            booking.bookingDate.toVerbalDateTime,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
