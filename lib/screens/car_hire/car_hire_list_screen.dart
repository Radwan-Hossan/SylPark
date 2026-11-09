import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/car_hire_provider.dart';
import '../../widgets/cards/car_hire_card.dart';
import '../../widgets/common/empty_state_widget.dart';
import 'car_hire_details_screen.dart';
import 'car_hire_request_screen.dart';
import 'my_car_hire_screen.dart';

class CarHireListScreen extends StatefulWidget {
  const CarHireListScreen({super.key});

  @override
  State<CarHireListScreen> createState() => _CarHireListScreenState();
}

class _CarHireListScreenState extends State<CarHireListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CarHireProvider>(context, listen: false).fetchVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hireProvider = Provider.of<CarHireProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Car Hire with Driver'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyCarHireScreen()),
              );
            },
            icon: const Icon(
              Icons.history_rounded,
              size: 18,
              color: AppColors.primaryGreen,
            ),
            label: const Text(
              'My Hires',
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
          // Banner Notice
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
                    Icons.airline_seat_recline_extra_rounded,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Request a comfortable vehicle with a verified professional chauffeur for your journey in Sylhet.',
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
            child: hireProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  )
                : hireProvider.vehicles.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.directions_car_rounded,
                    title: 'No Hire Vehicles Available',
                    message: 'Hire fleet is currently being updated. Please check back shortly.',
                    buttonText: 'Refresh',
                    onButtonPressed: () => hireProvider.fetchVehicles(),
                  )
                : RefreshIndicator(
                    onRefresh: () => hireProvider.fetchVehicles(),
                    color: AppColors.primaryGreen,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100, top: 4),
                      itemCount: hireProvider.vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = hireProvider.vehicles[index];
                        return CarHireCard(
                          vehicle: vehicle,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CarHireDetailsScreen(vehicle: vehicle),
                              ),
                            );
                          },
                          onHireTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CarHireRequestScreen(vehicle: vehicle),
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
