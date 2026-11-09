import '../../core/constants/api_config.dart';
import '../../models/car_rental_model.dart';
import '../api/api_client.dart';

class CarRentalService {
  Future<List<CarRentalVehicleModel>> getVehicles() async {
    final response = await ApiClient.get(
      ApiConfig.carRental,
      requiresAuth: false,
    );
    if (response != null && response['success'] == true) {
      final list = response['data'] as List<dynamic>? ?? [];
      return list.map((item) => CarRentalVehicleModel.fromJson(item)).toList();
    } else {
      throw ApiException(
        response?['message'] ?? 'Failed to load rental vehicles.',
      );
    }
  }

  Future<CarRentalVehicleModel> getVehicleById(String id) async {
    final response = await ApiClient.get(
      '${ApiConfig.carRental}/$id',
      requiresAuth: false,
    );
    if (response != null && response['success'] == true) {
      return CarRentalVehicleModel.fromJson(response['data']);
    } else {
      throw ApiException(response?['message'] ?? 'Vehicle not found.');
    }
  }

  Future<CarRentalBookingModel> createRentalRequest({
    required String vehicleId,
    required String startDate,
    required String endDate,
    required int durationDays,
    required String driverOption, // 'self-drive' | 'with-driver'
    String? additionalNotes,
  }) async {
    final response = await ApiClient.post(ApiConfig.carRentalBookings, {
      'vehicleId': vehicleId,
      'startDate': startDate.trim(),
      'endDate': endDate.trim(),
      'durationDays': durationDays,
      'driverOption': driverOption,
      'additionalNotes': additionalNotes ?? '',
    });

    if (response != null && response['success'] == true) {
      return CarRentalBookingModel.fromJson(response['data']);
    } else {
      throw ApiException(
        response?['message'] ?? 'Failed to submit rental request.',
      );
    }
  }

  Future<List<CarRentalBookingModel>> getMyRentalRequests() async {
    final response = await ApiClient.get('${ApiConfig.carRentalBookings}/my');
    if (response != null && response['success'] == true) {
      final list = response['data'] as List<dynamic>? ?? [];
      return list.map((item) => CarRentalBookingModel.fromJson(item)).toList();
    } else {
      throw ApiException(
        response?['message'] ?? 'Failed to load rental requests.',
      );
    }
  }
}
