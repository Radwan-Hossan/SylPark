import '../../core/constants/api_config.dart';
import '../../models/car_hire_model.dart';
import '../api/api_client.dart';

class CarHireService {
  Future<List<CarHireVehicleModel>> getVehicles() async {
    final response = await ApiClient.get(
      ApiConfig.carHire,
      requiresAuth: false,
    );
    if (response != null && response['success'] == true) {
      final list = response['data'] as List<dynamic>? ?? [];
      return list.map((item) => CarHireVehicleModel.fromJson(item)).toList();
    } else {
      throw ApiException(
        response?['message'] ?? 'Failed to load car hire vehicles.',
      );
    }
  }

  Future<CarHireVehicleModel> getVehicleById(String id) async {
    final response = await ApiClient.get(
      '${ApiConfig.carHire}/$id',
      requiresAuth: false,
    );
    if (response != null && response['success'] == true) {
      return CarHireVehicleModel.fromJson(response['data']);
    } else {
      throw ApiException(response?['message'] ?? 'Vehicle not found.');
    }
  }

  Future<CarHireBookingModel> createHireRequest({
    required String vehicleId,
    required String pickupLocation,
    required String destination,
    required String travelDate,
    required String pickupTime,
    required int passengerCount,
    String? additionalNotes,
  }) async {
    final response = await ApiClient.post(ApiConfig.carHireBookings, {
      'vehicleId': vehicleId,
      'pickupLocation': pickupLocation.trim(),
      'destination': destination.trim(),
      'travelDate': travelDate.trim(),
      'pickupTime': pickupTime.trim(),
      'passengerCount': passengerCount,
      'additionalNotes': additionalNotes ?? '',
    });

    if (response != null && response['success'] == true) {
      return CarHireBookingModel.fromJson(response['data']);
    } else {
      throw ApiException(
        response?['message'] ?? 'Failed to submit car hire request.',
      );
    }
  }

  Future<List<CarHireBookingModel>> getMyHireRequests() async {
    final response = await ApiClient.get('${ApiConfig.carHireBookings}/my');
    if (response != null && response['success'] == true) {
      final list = response['data'] as List<dynamic>? ?? [];
      return list.map((item) => CarHireBookingModel.fromJson(item)).toList();
    } else {
      throw ApiException(
        response?['message'] ?? 'Failed to load hire requests.',
      );
    }
  }
}
