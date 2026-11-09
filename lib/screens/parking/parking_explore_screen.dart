import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/parking_provider.dart';
import '../../widgets/cards/parking_card.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../bookings/booking_flow_screen.dart';
import '../map/sylhet_map_screen.dart';
import 'parking_details_screen.dart';

class ParkingExploreScreen extends StatefulWidget {
  const ParkingExploreScreen({super.key});

  @override
  State<ParkingExploreScreen> createState() => _ParkingExploreScreenState();
}

class _ParkingExploreScreenState extends State<ParkingExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ParkingProvider>(context, listen: false);
      _searchController.text = provider.searchQuery;
      provider.fetchParking();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parkingProvider = Provider.of<ParkingProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Explore Parking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded),
            tooltip: 'View Map',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SylhetMapScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: 'Filters',
            onPressed: () => _showFilterModal(context, parkingProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        parkingProvider.setSearchQuery(val);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search by parking or area name...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        parkingProvider.setSearchQuery('');
                      },
                    ),
                ],
              ),
            ),
          ),

          // Horizontal Filter Chips
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildFilterChip(
                  label: parkingProvider.selectedArea,
                  isSelected: parkingProvider.selectedArea != 'All Areas',
                  onTap: () => _showAreaPicker(context, parkingProvider),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: parkingProvider.selectedVehicleType,
                  isSelected:
                      parkingProvider.selectedVehicleType != 'All Vehicles',
                  onTap: () => _showVehiclePicker(context, parkingProvider),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: parkingProvider.selectedParkingType,
                  isSelected:
                      parkingProvider.selectedParkingType != 'All Types',
                  onTap: () => _showParkingTypePicker(context, parkingProvider),
                ),
                const SizedBox(width: 8),
                if (parkingProvider.selectedArea != 'All Areas' ||
                    parkingProvider.selectedVehicleType != 'All Vehicles' ||
                    parkingProvider.selectedParkingType != 'All Types' ||
                    parkingProvider.searchQuery.isNotEmpty)
                  ActionChip(
                    label: const Text(
                      'Reset',
                      style: TextStyle(fontSize: 12, color: AppColors.danger),
                    ),
                    backgroundColor: AppColors.danger.withOpacity(0.08),
                    onPressed: () {
                      _searchController.clear();
                      parkingProvider.resetFilters();
                    },
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Parking Cards List
          Expanded(
            child: parkingProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  )
                : parkingProvider.parkingList.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.local_parking_rounded,
                    title: 'No Parking Spaces Found',
                    message: 'We could not find any parking spots matching your current search or filter criteria in Sylhet.',
                    buttonText: 'Reset Filters',
                    onButtonPressed: () {
                      _searchController.clear();
                      parkingProvider.resetFilters();
                    },
                  )
                : RefreshIndicator(
                    onRefresh: () => parkingProvider.fetchParking(),
                    color: AppColors.primaryGreen,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100, top: 4),
                      itemCount: parkingProvider.parkingList.length,
                      itemBuilder: (context, index) {
                        final parking = parkingProvider.parkingList[index];
                        final isFav = parkingProvider.isFavorite(parking.id);

                        return ParkingCard(
                          parking: parking,
                          isFavorite: isFav,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ParkingDetailsScreen(parking: parking),
                              ),
                            );
                          },
                          onBookTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BookingFlowScreen(parking: parking),
                              ),
                            );
                          },
                          onFavoriteTap: () =>
                              parkingProvider.toggleFavorite(parking.id),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showAreaPicker(BuildContext context, ParkingProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ListView.builder(
        shrinkWrap: true,
        itemCount: AppConstants.sylhetAreas.length,
        itemBuilder: (ctx, i) {
          final area = AppConstants.sylhetAreas[i];
          return ListTile(
            title: Text(
              area,
              style: TextStyle(
                fontWeight: provider.selectedArea == area
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            trailing: provider.selectedArea == area
                ? const Icon(Icons.check, color: AppColors.primaryGreen)
                : null,
            onTap: () {
              provider.setAreaFilter(area);
              Navigator.pop(ctx);
            },
          );
        },
      ),
    );
  }

  void _showVehiclePicker(BuildContext context, ParkingProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ListView.builder(
        shrinkWrap: true,
        itemCount: AppConstants.vehicleTypes.length,
        itemBuilder: (ctx, i) {
          final vType = AppConstants.vehicleTypes[i];
          return ListTile(
            title: Text(
              vType,
              style: TextStyle(
                fontWeight: provider.selectedVehicleType == vType
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            trailing: provider.selectedVehicleType == vType
                ? const Icon(Icons.check, color: AppColors.primaryGreen)
                : null,
            onTap: () {
              provider.setVehicleFilter(vType);
              Navigator.pop(ctx);
            },
          );
        },
      ),
    );
  }

  void _showParkingTypePicker(BuildContext context, ParkingProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ListView.builder(
        shrinkWrap: true,
        itemCount: AppConstants.parkingTypes.length,
        itemBuilder: (ctx, i) {
          final pType = AppConstants.parkingTypes[i];
          return ListTile(
            title: Text(
              pType,
              style: TextStyle(
                fontWeight: provider.selectedParkingType == pType
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            trailing: provider.selectedParkingType == pType
                ? const Icon(Icons.check, color: AppColors.primaryGreen)
                : null,
            onTap: () {
              provider.setParkingTypeFilter(pType);
              Navigator.pop(ctx);
            },
          );
        },
      ),
    );
  }

  void _showFilterModal(BuildContext context, ParkingProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sort & Filter Parking',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Sort By',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Highest Rating'),
                    selected: provider.sortBy == 'rating',
                    onSelected: (val) {
                      provider.setSortBy('rating');
                      Navigator.pop(ctx);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Price: Low to High'),
                    selected: provider.sortBy == 'price_asc',
                    onSelected: (val) {
                      provider.setSortBy('price_asc');
                      Navigator.pop(ctx);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Price: High to Low'),
                    selected: provider.sortBy == 'price_desc',
                    onSelected: (val) {
                      provider.setSortBy('price_desc');
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
