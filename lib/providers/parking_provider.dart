import 'package:flutter/foundation.dart';

import '../models/parking_model.dart';
import '../services/parking/parking_service.dart';

class ParkingProvider with ChangeNotifier {
  final ParkingService _parkingService = ParkingService();

  List<ParkingModel> _parkingList = [];
  List<String> _favoriteIds = [];
  List<ParkingModel> _favoriteList = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _searchQuery = '';
  String _selectedArea = 'All Areas';
  String _selectedVehicleType = 'All Vehicles';
  String _selectedParkingType = 'All Types';
  double? _maxPrice;
  String _sortBy = 'rating';

  List<ParkingModel> get parkingList => _parkingList;
  List<String> get favoriteIds => _favoriteIds;
  List<ParkingModel> get favoriteList => _favoriteList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;
  String get selectedArea => _selectedArea;
  String get selectedVehicleType => _selectedVehicleType;
  String get selectedParkingType => _selectedParkingType;
  double? get maxPrice => _maxPrice;
  String get sortBy => _sortBy;

  // Filtered parking list
  List<ParkingModel> get filteredParking {
    return _parkingList;
  }

  // Home screen slices
  List<ParkingModel> get nearbyParking => _parkingList.take(3).toList();
  List<ParkingModel> get popularParking =>
      (_parkingList.toList()..sort((a, b) => b.rating.compareTo(a.rating)))
          .take(4)
          .toList();
  List<ParkingModel> get recommendedParking =>
      (_parkingList.toList()
            ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount)))
          .take(3)
          .toList();

  bool isFavorite(String parkingId) => _favoriteIds.contains(parkingId);

  Future<void> fetchParking({bool isRefresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _parkingList = await _parkingService.getParkingList(
        search: _searchQuery.isEmpty ? null : _searchQuery,
        area: _selectedArea,
        vehicleType: _selectedVehicleType,
        parkingType: _selectedParkingType,
        maxPrice: _maxPrice,
        sort: _sortBy,
      );

      // Also refresh favorites
      await loadFavorites();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    try {
      _favoriteIds = await _parkingService.getFavoriteIds();
      _favoriteList = _parkingList
          .where((p) => _favoriteIds.contains(p.id))
          .toList();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggleFavorite(String parkingId) async {
    final currentlyFav = _favoriteIds.contains(parkingId);

    // Optimistic UI update
    if (currentlyFav) {
      _favoriteIds.remove(parkingId);
      _favoriteList.removeWhere((p) => p.id == parkingId);
    } else {
      _favoriteIds.add(parkingId);
      final item = _parkingList.firstWhere(
        (p) => p.id == parkingId,
        orElse: () => _parkingList.first,
      );
      if (!_favoriteList.contains(item)) {
        _favoriteList.add(item);
      }
    }
    notifyListeners();

    try {
      if (currentlyFav) {
        await _parkingService.removeFavorite(parkingId);
      } else {
        await _parkingService.addFavorite(parkingId);
      }
    } catch (e) {
      // Revert if API fails
      if (currentlyFav) {
        _favoriteIds.add(parkingId);
      } else {
        _favoriteIds.remove(parkingId);
      }
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    fetchParking();
  }

  void setAreaFilter(String area) {
    _selectedArea = area;
    fetchParking();
  }

  void setVehicleFilter(String vehicleType) {
    _selectedVehicleType = vehicleType;
    fetchParking();
  }

  void setParkingTypeFilter(String type) {
    _selectedParkingType = type;
    fetchParking();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    fetchParking();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedArea = 'All Areas';
    _selectedVehicleType = 'All Vehicles';
    _selectedParkingType = 'All Types';
    _maxPrice = null;
    _sortBy = 'rating';
    fetchParking();
  }
}
