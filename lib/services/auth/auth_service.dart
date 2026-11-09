import '../../core/constants/api_config.dart';
import '../../models/user_model.dart';
import '../api/api_client.dart';

class AuthService {
  Future<UserModel> login(String email, String password) async {
    final response = await ApiClient.post(ApiConfig.login, {
      'email': email.trim(),
      'password': password,
    }, requiresAuth: false);

    if (response != null && response['success'] == true) {
      final token = response['data']['token'] as String;
      await ApiClient.saveToken(token);
      return UserModel.fromJson(response['data']['user']);
    } else {
      throw ApiException(response?['message'] ?? 'Login failed.');
    }
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await ApiClient.post(ApiConfig.register, {
      'name': name.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'password': password,
      'confirmPassword': confirmPassword,
    }, requiresAuth: false);

    if (response != null && response['success'] == true) {
      final token = response['data']['token'] as String;
      await ApiClient.saveToken(token);
      return UserModel.fromJson(response['data']['user']);
    } else {
      throw ApiException(response?['message'] ?? 'Registration failed.');
    }
  }

  Future<UserModel> getMe() async {
    final response = await ApiClient.get(ApiConfig.authMe);
    if (response != null && response['success'] == true) {
      return UserModel.fromJson(response['data']['user']);
    } else {
      throw ApiException(response?['message'] ?? 'Failed to retrieve profile.');
    }
  }

  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? avatar,
    String? vehicleInfo,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;
    if (avatar != null) body['avatar'] = avatar;
    if (vehicleInfo != null) body['vehicleInfo'] = vehicleInfo;

    final response = await ApiClient.put(ApiConfig.userProfile, body);
    if (response != null && response['success'] == true) {
      return UserModel.fromJson(response['data']['user']);
    } else {
      throw ApiException(response?['message'] ?? 'Failed to update profile.');
    }
  }

  Future<void> logout() async {
    await ApiClient.removeToken();
  }

  Future<bool> hasSavedToken() async {
    final token = await ApiClient.getToken();
    return token != null && token.isNotEmpty;
  }
}
