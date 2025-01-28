import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/widgets/snackbar.dart';

import '../../models/bookings/booking_model.dart';
import '../../services/backend_service.dart';

class ChangeBookingDetailStatusProvider extends ChangeNotifier {
  final BuildContext context;
  late BackendService _backendService;
  final DocsBooking booking;

  ChangeBookingDetailStatusProvider(this.context, this.booking)
      : _backendService = Provider.of<BackendService>(context);

  String updatedBookingStatus = 'Pending';
  String rejectionMessage = '';
  bool acceptedLoading = false;
  bool rejectedLoading = false;

  Future<void> updateBookingStatusToAccepted() async {
    updatedBookingStatus = "Accepted";
    acceptedLoading = true;
    notifyListeners();

    final response = await _backendService.changeBookingStatus(
      bid: booking.id,
      bookingStatus: updatedBookingStatus,
      rejectionMessage: rejectionMessage,
    );

    if (response.result != null &&
        response.statusCode == 200 &&
        response.errorMessage == null) {
      context.pop();
      SnackBarHelper.showSnackbar(
        context: context,
        successMessage: response.message,
      );
      notifyListeners();
    }
    acceptedLoading = false;
    notifyListeners();
  }

  Future<void> updateBookingStatusToRejected() async {
    updatedBookingStatus = "Rejected";
    rejectedLoading = true;
    notifyListeners();

    final response = await _backendService.changeBookingStatus(
      bid: booking.id,
      bookingStatus: 'Rejected',
      rejectionMessage: rejectionMessage,
    );

    if (response.result != null &&
        response.statusCode == 200 &&
        response.errorMessage == null) {
      context.pop();
      SnackBarHelper.showSnackbar(
        context: context,
        successMessage: response.message,
      );
      notifyListeners();
    }
    rejectedLoading = false;
    notifyListeners();
  }
}

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({
    super.key,
    required this.booking,
  });
  final DocsBooking booking;

  @override
  Widget build(BuildContext context) {
    //TODO: implement the UI for the booking details screen
    //same as in user jasati
    //yesma organization lai user ko detail ni dekhauna parxa booking bhitra chha
    //golo golo golo ma photo dekhauni usewr ko chha bhane chha chaina bhane icons.person bhanne dekhaune

    return const Placeholder();
  }
}
