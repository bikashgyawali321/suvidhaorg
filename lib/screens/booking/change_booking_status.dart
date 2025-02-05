import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/providers/organization_provider.dart';
import 'package:suvidhaorg/screens/home/bookings.dart';
import 'package:suvidhaorg/services/backend_service.dart';
import 'package:suvidhaorg/widgets/custom_button.dart';
import 'package:suvidhaorg/widgets/form_bottom_sheet_header.dart';
import 'package:suvidhaorg/widgets/snackbar.dart';

/// Provider to manage booking status changes
class ChangeBookingStatusProvider extends ChangeNotifier {
  final BuildContext context;
  final String bookingId;
  bool loading = false;
  late BackendService backendService;
  late BookingProvider bookingProvider;
  late OrganizationProvider organizationProvider;
  String? rejectionMessage = '';
  bool? isCompletedBooking;

  ChangeBookingStatusProvider(this.context, this.bookingId,
      {this.isCompletedBooking}) {
    backendService = Provider.of<BackendService>(context, listen: false);
    bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    organizationProvider =
        Provider.of<OrganizationProvider>(context, listen: false);
  }

  Future<void> changeBookingStatusToAccepted() async {
    loading = true;
    notifyListeners();

    final response = await backendService.changeBookingStatus(
      bid: bookingId,
      bookingStatus: 'Accepted',
    );

    loading = false;
    notifyListeners();
    if (response.result != null && response.statusCode == 200) {
      await bookingProvider.fetchBookings(reset: true);
      context.go('/home');
      SnackBarHelper.showSnackbar(
        context: context,
        successMessage: response.message,
      );
    } else {
      context.pop();
      SnackBarHelper.showSnackbar(
        context: context,
        errorMessage: response.errorMessage,
      );
    }
  }

  Future<void> changeBookingStatusToRejected() async {
    loading = true;
    notifyListeners();

    final response = await backendService.changeBookingStatus(
      bid: bookingId,
      bookingStatus: 'Rejected',
      rejectionMessage: rejectionMessage,
    );

    loading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      await bookingProvider.fetchBookings(
        reset: true,
      );
      context.go('/home');

      SnackBarHelper.showSnackbar(
        context: context,
        successMessage: response.message,
      );
    } else {
      context.pop();
      SnackBarHelper.showSnackbar(
        context: context,
        errorMessage: response.errorMessage,
      );
    }
  }

  Future<void> changeBookingStatusToCompleted() async {
    loading = true;
    notifyListeners();

    final response = await backendService.changeBookingStatus(
      bid: bookingId,
      bookingStatus: 'Completed',
    );

    loading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      await bookingProvider.fetchBookings(
        reset: true,
      );
      await organizationProvider.getOrganizationData();
      context.go('/home');
      SnackBarHelper.showSnackbar(
        context: context,
        successMessage: response.message,
      );
    } else {
      context.pop();
      SnackBarHelper.showSnackbar(
        context: context,
        errorMessage: response.errorMessage,
      );
    }
  }
}

class ChangeBookingStatusBottomSheet extends StatelessWidget {
  final String bookingId;
  bool? isCpmpletedBooking;

  ChangeBookingStatusBottomSheet(
      {super.key, required this.bookingId, this.isCpmpletedBooking});

  static void show({
    required BuildContext context,
    required String bid,
    bool? isCompletedBooking,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ChangeNotifierProvider(
        create: (context) => ChangeBookingStatusProvider(
          context,
          bid,
          isCompletedBooking: isCompletedBooking ?? false,
        ),
        child: ChangeBookingStatusBottomSheet(bookingId: bid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeBookingStatusProvider>(
      builder: (context, provider, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormBottomSheetHeader(title: 'Change Booking Status'),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change the status of this booking ${provider.isCompletedBooking == true ? 'to completed' : ''}.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: provider.isCompletedBooking == true
                            ? 'Mark Completed'
                            : 'Accept',
                        onPressed: () async {
                          if (provider.isCompletedBooking == true) {
                            await provider.changeBookingStatusToCompleted();

                            return;
                          }
                          await provider.changeBookingStatusToAccepted();
                        },
                        loading: provider.loading,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        label: provider.isCompletedBooking == true
                            ? 'Not Now'
                            : 'Reject',
                        onPressed: () {
                          context.pop();
                          ShowBottomSheetWithRejectionMessage.show(
                            context,
                            bookingId,
                          );
                        },
                        backgroundColor: provider.isCompletedBooking == true
                            ? Colors.blue
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShowBottomSheetWithRejectionMessage extends StatelessWidget {
  const ShowBottomSheetWithRejectionMessage({super.key});

  static void show(BuildContext context, String bookingId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ChangeNotifierProvider(
        create: (context) => ChangeBookingStatusProvider(context, bookingId),
        child: const ShowBottomSheetWithRejectionMessage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangeBookingStatusProvider>();

    return Consumer<ChangeBookingStatusProvider>(
      builder: (context, value, child) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBottomSheetHeader(title: 'Reject Booking'),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Are you sure you want to reject this booking?',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        onChanged: (value) {
                          provider.rejectionMessage = value;
                        },
                        decoration: const InputDecoration(
                          label: Text('Rejection Reason (Optional)'),
                          hintText: 'Enter the reason for rejection',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomButton(
                              label: 'Not Now',
                              onPressed: () => context.pop(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomButton(
                              label: 'Reject',
                              onPressed: () async {
                                await provider.changeBookingStatusToRejected();
                              },
                              backgroundColor: Colors.red,
                              loading: provider.loading,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
