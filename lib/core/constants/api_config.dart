import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static const String _prefKeyCustomHost = 'custom_api_host';
  static const String _prefKeyIsEmulator = 'is_emulator_mode';

  // Default configuration
  // Physical phone default using current Wi-Fi IPv4
  static const String defaultPhysicalPhoneHost = '192.168.0.109';
  static const String defaultEmulatorHost = '10.0.2.2';
  static const int port = 3000;

  static String _activeHost = defaultPhysicalPhoneHost;
  static bool _isEmulator = false;

  /// Initialize config from SharedPreferences
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isEmulator = prefs.getBool(_prefKeyIsEmulator) ?? false;
    _activeHost =
        prefs.getString(_prefKeyCustomHost) ??
        (_isEmulator ? defaultEmulatorHost : defaultPhysicalPhoneHost);
  }

  /// Get current API Base URL
  static String get baseUrl {
    return 'http://$_activeHost:$port/api';
  }

  static String get currentHost => _activeHost;
  static bool get isEmulator => _isEmulator;

  /// Update the server host dynamically (e.g. from app settings)
  static Future<void> updateHost(
    String newHost, {
    bool isEmulator = false,
  }) async {
    final cleanHost = newHost
        .trim()
        .replaceAll('http://', '')
        .replaceAll(':3000', '')
        .replaceAll('/api', '');
    _activeHost = cleanHost.isEmpty ? defaultPhysicalPhoneHost : cleanHost;
    _isEmulator = isEmulator;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKeyCustomHost, _activeHost);
    await prefs.setBool(_prefKeyIsEmulator, _isEmulator);
  }

  // API Endpoints
  static String get health => '$baseUrl/health';
  static String get login => '$baseUrl/auth/login';
  static String get register => '$baseUrl/auth/register';
  static String get authMe => '$baseUrl/auth/me';
  static String get userProfile => '$baseUrl/users/me';
  static String get parking => '$baseUrl/parking';
  static String get parkingSearch => '$baseUrl/parking/search';
  static String get favorites => '$baseUrl/favorites';
  static String get bookings => '$baseUrl/bookings';
  static String get carHire => '$baseUrl/car-hire';
  static String get carHireBookings => '$baseUrl/car-hire/bookings';
  static String get carRental => '$baseUrl/car-rental';
  static String get carRentalBookings => '$baseUrl/car-rental/bookings';
}
