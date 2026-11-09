import '../../core/constants/api_config.dart';
import '../../models/booking_model.dart';
import '../api/api_client.dart';

class BookingService {
  Future<BookingModel> createBooking({
    required String parkingId,
    required String vehicleType,
    required String vehiclePlate,
    required String bookingDate,
    required String startTime,
    required String endTime,
    required int durationHours,
    String? notes,
  }) async {
    final response = await ApiClient.post(ApiConfig.bookings, {
      'parkingId': parkingId,
      'vehicleType': vehicleType,
      'vehiclePlate': vehiclePlate,
      'bookingDate': bookingDate,
      'startTime': startTime,
      'endTime': endTime,
      'durationHours': durationHours,
      'notes': notes ?? '',
    });

    if (response != null && response['success'] == true) {
      return BookingModel.fromJson(response['data']);
    } else {
      throw ApiException(
        response?['message'] ?? 'Failed to submit parking booking.',
      );
    }
  }

  Future<List<BookingModel>> getMyBookings({String? status}) async {
    final queryParams = <String, String>{};
    if (status != null && status != 'all') queryParams['status'] = status;

    final uri = Uri.parse(ApiConfig.bookings)
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await ApiClient.get(uri.toString());
    if (response != null && response['success'] == true) {
      final list = response['data'] as List<dynamic>? ?? [];
      return list.map((item) => BookingModel.fromJson(item)).toList();
    } else {
      throw ApiException(response?['message'] ?? 'Failed to fetch bookings.');
    }
  }

  Future<BookingModel> cancelBooking(String bookingId) async {
    final url = '${ApiConfig.bookings}/$bookingId/cancel';
    final response = await ApiClient.patch(url);

    if (response != null && response['success'] == true) {
      return BookingModel.fromJson(response['data']);
    } else {
      throw ApiException(response?['message'] ?? 'Failed to cancel booking.');
    }
  }
}
