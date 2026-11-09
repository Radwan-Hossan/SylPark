import 'package:flutter/foundation.dart';

import '../models/booking_model.dart';
import '../services/bookings/booking_service.dart';

class BookingProvider with ChangeNotifier {
  final BookingService _bookingService = BookingService();

  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _activeTab = 'Ongoing'; // 'Ongoing', 'Completed', 'Cancelled'

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get activeTab => _activeTab;

  List<BookingModel> get ongoingBookings =>
      _bookings.where((b) => b.status.toLowerCase() == 'ongoing').toList();

  List<BookingModel> get completedBookings =>
      _bookings.where((b) => b.status.toLowerCase() == 'completed').toList();

  List<BookingModel> get cancelledBookings =>
      _bookings.where((b) => b.status.toLowerCase() == 'cancelled').toList();

  List<BookingModel> get currentTabBookings {
    switch (_activeTab.toLowerCase()) {
      case 'completed':
        return completedBookings;
      case 'cancelled':
        return cancelledBookings;
      case 'ongoing':
      default:
        return ongoingBookings;
    }
  }

  void setActiveTab(String tab) {
    _activeTab = tab;
    notifyListeners();
  }

  Future<void> fetchBookings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookings = await _bookingService.getMyBookings();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<BookingModel?> createBooking({
    required String parkingId,
    required String vehicleType,
    required String vehiclePlate,
    required String bookingDate,
    required String startTime,
    required String endTime,
    required int durationHours,
    String? notes,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newBooking = await _bookingService.createBooking(
        parkingId: parkingId,
        vehicleType: vehicleType,
        vehiclePlate: vehiclePlate,
        bookingDate: bookingDate,
        startTime: startTime,
        endTime: endTime,
        durationHours: durationHours,
        notes: notes,
      );

      _bookings.insert(0, newBooking);
      _isLoading = false;
      notifyListeners();
      return newBooking;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      final updated = await _bookingService.cancelBooking(bookingId);
      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookings[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
