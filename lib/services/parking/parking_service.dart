import '../../core/constants/api_config.dart';
import '../../models/parking_model.dart';
import '../api/api_client.dart';

class ParkingService {
  Future<List<ParkingModel>> getParkingList({
    String? search,
    String? area,
    String? vehicleType,
    String? parkingType,
    double? maxPrice,
    String? sort,
  }) async {
    final queryParams = <String, String>{};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (area != null && area != 'All Areas') queryParams['area'] = area;
    if (vehicleType != null && vehicleType != 'All Vehicles') {
      queryParams['vehicleType'] = vehicleType;
    }
    if (parkingType != null && parkingType != 'All Types') {
      queryParams['parkingType'] = parkingType;
    }
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
    if (sort != null) queryParams['sort'] = sort;

    final uri = Uri.parse(ApiConfig.parking)
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);
    final response = await ApiClient.get(uri.toString(), requiresAuth: false);

    if (response != null && response['success'] == true) {
      final list = response['data'] as List<dynamic>? ?? [];
      return list.map((item) => ParkingModel.fromJson(item)).toList();
    } else {
      throw ApiException(
        response?['message'] ?? 'Failed to load parking list.',
      );
    }
  }

  Future<List<ParkingModel>> searchParking(String query) async {
    final uri = Uri.parse(ApiConfig.parkingSearch)
        .replace(queryParameters: {'q': query});
    final response = await ApiClient.get(uri.toString(), requiresAuth: false);

    if (response != null && response['success'] == true) {
      final list = response['data'] as List<dynamic>? ?? [];
      return list.map((item) => ParkingModel.fromJson(item)).toList();
    } else {
      throw ApiException(response?['message'] ?? 'Search failed.');
    }
  }

  Future<ParkingModel> getParkingById(String id) async {
    final url = '${ApiConfig.parking}/$id';
    final response = await ApiClient.get(url, requiresAuth: false);

    if (response != null && response['success'] == true) {
      return ParkingModel.fromJson(response['data']);
    } else {
      throw ApiException(response?['message'] ?? 'Parking spot not found.');
    }
  }

  Future<List<String>> getFavoriteIds() async {
    final response = await ApiClient.get(ApiConfig.favorites);
    if (response != null && response['success'] == true) {
      final ids = response['favoriteIds'] as List<dynamic>? ?? [];
      return ids.map((e) => e.toString()).toList();
    }
    return [];
  }

  Future<List<ParkingModel>> getFavoriteParkings() async {
    final response = await ApiClient.get(ApiConfig.favorites);
    if (response != null && response['success'] == true) {
      final list = response['data'] as List<dynamic>? ?? [];
      return list.map((item) => ParkingModel.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> addFavorite(String parkingId) async {
    await ApiClient.post(ApiConfig.favorites, {'parkingId': parkingId});
  }

  Future<void> removeFavorite(String parkingId) async {
    await ApiClient.delete('${ApiConfig.favorites}/$parkingId');
  }
}
