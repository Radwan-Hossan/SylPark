import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/parking_provider.dart';
import '../../widgets/cards/parking_card.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../bookings/booking_flow_screen.dart';
import '../parking/parking_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parkingProvider = Provider.of<ParkingProvider>(context);
    final favList = parkingProvider.favoriteList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Saved Favorite Spots'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: favList.isEmpty
          ? EmptyStateWidget(
              icon: Icons.favorite_border_rounded,
              title: 'No Favorites Saved',
              message: 'Tap the heart icon on any Sylhet parking card to save it to your favorites list.',
              buttonText: 'Explore Parking',
              onButtonPressed: () => Navigator.pop(context),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: favList.length,
              itemBuilder: (context, index) {
                final parking = favList[index];
                return ParkingCard(
                  parking: parking,
                  isFavorite: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ParkingDetailsScreen(parking: parking),
                      ),
                    );
                  },
                  onBookTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingFlowScreen(parking: parking),
                      ),
                    );
                  },
                  onFavoriteTap: () =>
                      parkingProvider.toggleFavorite(parking.id),
                );
              },
            ),
    );
  }
}
