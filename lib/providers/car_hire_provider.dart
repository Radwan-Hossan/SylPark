import 'package:flutter/foundation.dart';

import '../models/car_hire_model.dart';
import '../services/car_hire/car_hire_service.dart';

class CarHireProvider with ChangeNotifier {
  final CarHireService _carHireService = CarHireService();

  List<CarHireVehicleModel> _vehicles = [];
  List<CarHireBookingModel> _myRequests = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CarHireVehicleModel> get vehicles => _vehicles;
  List<CarHireBookingModel> get myRequests => _myRequests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchVehicles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _vehicles = await _carHireService.getVehicles();
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
      _myRequests = await _carHireService.getMyHireRequests();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CarHireBookingModel?> submitHireRequest({
    required String vehicleId,
    required String pickupLocation,
    required String destination,
    required String travelDate,
    required String pickupTime,
    required int passengerCount,
    String? additionalNotes,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final req = await _carHireService.createHireRequest(
        vehicleId: vehicleId,
        pickupLocation: pickupLocation,
        destination: destination,
        travelDate: travelDate,
        pickupTime: pickupTime,
        passengerCount: passengerCount,
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
