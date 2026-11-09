import 'package:flutter/foundation.dart';

import '../models/car_rental_model.dart';
import '../services/car_rental/car_rental_service.dart';

class CarRentalProvider with ChangeNotifier {
  final CarRentalService _carRentalService = CarRentalService();

  List<CarRentalVehicleModel> _vehicles = [];
  List<CarRentalBookingModel> _myRequests = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CarRentalVehicleModel> get vehicles => _vehicles;
  List<CarRentalBookingModel> get myRequests => _myRequests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchVehicles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _vehicles = await _carRentalService.getVehicles();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyRequests() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _myRequests = await _carRentalService.getMyRentalRequests();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CarRentalBookingModel?> submitRentalRequest({
    required String vehicleId,
    required String startDate,
    required String endDate,
    required int durationDays,
    required String driverOption,
    String? additionalNotes,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final req = await _carRentalService.createRentalRequest(
        vehicleId: vehicleId,
        startDate: startDate,
        endDate: endDate,
        durationDays: durationDays,
        driverOption: driverOption,
        additionalNotes: additionalNotes,
      );

      _myRequests.insert(0, req);
      _isLoading = false;
      notifyListeners();
      return req;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
