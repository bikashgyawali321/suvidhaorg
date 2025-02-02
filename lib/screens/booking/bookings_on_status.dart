import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/extensions/extensions.dart';
import 'package:suvidhaorg/models/bookings/booking_model.dart';
import 'package:suvidhaorg/models/pagination/list_model.dart';
import 'package:suvidhaorg/providers/organization_provider.dart';
import 'package:suvidhaorg/widgets/loading_screen.dart';

import '../../services/backend_service.dart';

class BookingOnStatusProvider extends ChangeNotifier {
  List<DocsBooking> bookings = [];
  bool loading = false;
  bool hasMore = true;
  bool loadingMore = false;
  String searchTerm = '';
  final String bookingStatus;
  final BuildContext context;
  late BackendService _backendService;
  late OrganizationProvider organizationProvider;

  ListingSchema? listingSchema;

  BookingOnStatusProvider(this.context, {required this.bookingStatus}) {
    initialize();
  }

  void initialize() {
    _backendService = Provider.of<BackendService>(context, listen: false);
    organizationProvider =
        Provider.of<OrganizationProvider>(context, listen: false);
    listingSchema = ListingSchema(
      limit: 50,
      page: 1,
      status: bookingStatus,
    );
    fetchBookings();
  }

  Future<void> fetchBookings({bool reset = false}) async {
    if (reset) {
      listingSchema!.page = 1;
      bookings.clear();
      hasMore = true;
      notifyListeners();
    }

    if (loading || !hasMore) return;

    loading = true;
    notifyListeners();
    if (organizationProvider.organization == null) {
      loading = false;
      notifyListeners();
      return;
    }
    final response =
        await _backendService.getAllBookings(listingSchema: listingSchema!);

    if (response.result != null &&
        response.statusCode == 200 &&
        response.errorMessage == null) {
      List<DocsBooking> fetchedBookings =
          BookingArrayResponse.fromJson(response.result).docs;

      if (fetchedBookings.isEmpty ||
          fetchedBookings.length < listingSchema!.limit) {
        hasMore = false;
      }

      bookings.addAll(fetchedBookings);
    } else {
      hasMore = false;
    }

    loading = false;
    notifyListeners();
  }

  void fetchMoreBookings() async {
    if (loadingMore || !hasMore) return;

    loadingMore = true;
    listingSchema!.page += 1;
    notifyListeners();

    await fetchBookings();

    loadingMore = false;
    notifyListeners();
  }

  void updateSearchTerm(String term) {
    searchTerm = term;
    notifyListeners();
  }
}

class BookingsOnStatusScreen extends StatelessWidget {
  const BookingsOnStatusScreen({super.key, required this.status});
  final String status;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingOnStatusProvider(context, bookingStatus: status),
      builder: (context, child) {
        return Consumer<BookingOnStatusProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('$status Bookings'),
                centerTitle: false,
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    if (provider.loading)
                      const Center(child: LoadingScreen())
                    else if (provider.bookings.isEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.inbox_outlined,
                              size: 80,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No ${status.toLowerCase()} bookings found!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'Looks like there are no ${status.toLowerCase()} bookings available.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )
                    else
                      NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent &&
                              provider.hasMore) {
                            provider.fetchMoreBookings();
                          }
                          return false;
                        },
                        child: RefreshIndicator(
                          onRefresh: () => provider.fetchBookings(
                            reset: true,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 35),
                            child: Column(
                              children: [
                                for (final booking in provider.bookings) ...[
                                  ListTile(
                                    title: Text(booking.serviceName.name),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          booking.user.userName,
                                        ),
                                        Spacer(),
                                        Text(
                                          booking.bookingDate
                                              .toLocal()
                                              .toVerbalDateTimeWithDay,
                                        ),
                                      ],
                                    ),
                                    trailing: Icon(Icons.chevron_right),
                                    onTap: () {
                                      context.push(
                                        '/booking_details',
                                        extra: booking,
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: -2,
                      left: 00,
                      right: 0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        color: Theme.of(context).appBarTheme.foregroundColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (value) =>
                                provider.updateSearchTerm(value),
                            decoration: const InputDecoration(
                              hintText: 'Search bookings...',
                              prefixIcon: Icon(
                                Icons.search,
                                size: 30,
                              ),
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
