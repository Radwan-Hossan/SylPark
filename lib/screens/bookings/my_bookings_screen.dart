import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/cards/booking_card.dart';
import '../../widgets/common/empty_state_widget.dart';
import 'booking_confirmation_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  final VoidCallback? onExploreTap;

  const MyBookingsScreen({super.key, this.onExploreTap});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).fetchBookings();
    });
  }

  void _showCancelConfirmation(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Cancel Parking Booking?',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to cancel this booking reservation? Your slot will be released back to other drivers.',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              final provider = Provider.of<BookingProvider>(
                context,
                listen: false,
              );
              final success = await provider.cancelBooking(bookingId);
              if (mounted) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Booking cancelled successfully.'
                          : 'Failed to cancel booking.',
                    ),
                    backgroundColor: success
                        ? AppColors.darkGreen
                        : AppColors.danger,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Confirm Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final tabs = ['Ongoing', 'Completed', 'Cancelled'];
    final bookings = bookingProvider.currentTabBookings;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Booking'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Segmented Tab Bar (Matching Reference Design!)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: tabs.map((tab) {
                  final isSelected = bookingProvider.activeTab == tab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => bookingProvider.setActiveTab(tab),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryDark
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            tab,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // List of Bookings
          Expanded(
            child: bookingProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  )
                : bookings.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.calendar_today_outlined,
                    title: 'No ${bookingProvider.activeTab} Bookings',
                    message:
                        'You currently have no ${bookingProvider.activeTab.toLowerCase()} parking reservations in Sylhet.',
                    buttonText: 'Find Parking Spot',
                    onButtonPressed: widget.onExploreTap,
                  )
                : RefreshIndicator(
                    onRefresh: () => bookingProvider.fetchBookings(),
                    color: AppColors.primaryGreen,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100, top: 4),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return BookingCard(
                          booking: booking,
                          onDetailsTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BookingConfirmationScreen(booking: booking),
                              ),
                            );
                          },
                          onCancelTap: () =>
                              _showCancelConfirmation(context, booking.id),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
