import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/car_rental_provider.dart';
import '../../widgets/cards/car_rental_card.dart';
import '../../widgets/common/empty_state_widget.dart';
import 'car_rental_details_screen.dart';
import 'car_rental_request_screen.dart';
import 'my_car_rental_screen.dart';

class CarRentalListScreen extends StatefulWidget {
  const CarRentalListScreen({super.key});

  @override
  State<CarRentalListScreen> createState() => _CarRentalListScreenState();
}

class _CarRentalListScreenState extends State<CarRentalListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CarRentalProvider>(context, listen: false).fetchVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rentalProvider = Provider.of<CarRentalProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Car Rental (Daily)'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyCarRentalScreen()),
              );
            },
            icon: const Icon(
              Icons.history_rounded,
              size: 18,
              color: AppColors.primaryGreen,
            ),
            label: const Text(
              'My Rentals',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.key_rounded,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Rent insured vehicles per day with flexible self-drive or driver options across Sylhet.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Vehicle List
          Expanded(
            child: rentalProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  )
                : rentalProvider.vehicles.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.car_rental_rounded,
                    title: 'No Rental Fleet Found',
                    message: 'Daily rental fleet is currently offline.',
                    buttonText: 'Refresh',
                    onButtonPressed: () => rentalProvider.fetchVehicles(),
                  )
                : RefreshIndicator(
                    onRefresh: () => rentalProvider.fetchVehicles(),
                    color: AppColors.primaryGreen,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100, top: 4),
                      itemCount: rentalProvider.vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = rentalProvider.vehicles[index];
                        return CarRentalCard(
                          vehicle: vehicle,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CarRentalDetailsScreen(vehicle: vehicle),
                              ),
                            );
                          },
                          onRentTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CarRentalRequestScreen(vehicle: vehicle),
                              ),
                            );
                          },
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
