import 'dart:async';

import '../../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(
    String staffId,
    String password, {
    String? otp,
  }) async {
    try {
      final body = {
        'username': staffId,
        'password': password,
        'tax_payer_type': 'indi',
      };
      if (otp != null) {
        body['otp'] = otp;
      }
      final response = await _apiService.post('/adminauth/auth/login', body);
      return response;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
