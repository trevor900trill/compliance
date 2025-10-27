import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // TODO: Move to env and make multi env
  final String _baseUrl = "http://192.168.102.95/uat/nrs";
  static const bool useMockData = false; // Set to false to use actual API

  Future<dynamic> get(String url) async {
    if (useMockData) {
      return _handleMockGet(url);
    }

    final response = await http.get(Uri.parse('$_baseUrl$url'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to GET from $url');
    }
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    if (useMockData) {
      return _handleMockPost(url, body);
    }

    final response = await http.post(
      Uri.parse('$_baseUrl$url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to POST to $url');
    }
  }

  Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body,
  ) async {
    if (useMockData) {
      return _handleMockPut(url, body);
    }

    final response = await http.put(
      Uri.parse('$_baseUrl$url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to PUT to $url');
    }
  }

  Future<Map<String, dynamic>> delete(String url) async {
    if (useMockData) {
      return _handleMockDelete(url);
    }

    final response = await http.delete(Uri.parse('$_baseUrl$url'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to DELETE from $url');
    }
  }

  Future<dynamic> _handleMockGet(String url) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    switch (url) {
      case '/services':
        return {
          'services': [
            {
              'id': '1',
              'name': 'Business Permit',
              'description': 'Apply for a new business permit.',
            },
            {
              'id': '2',
              'name': 'Parking Ticket',
              'description': 'Pay for a parking ticket.',
            },
            {
              'id': '3',
              'name': 'Land Rates',
              'description': 'Pay for your land rates.',
            },
            {
              'id': '4',
              'name': 'Construction Permit',
              'description': 'Apply for a construction permit.',
            },
          ],
        };
      default:
        throw Exception('Mock GET handler not implemented for $url');
    }
  }

  Future<Map<String, dynamic>> _handleMockPost(
    String url,
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    switch (url) {
      case '/adminauth/auth/login':
        final staffId = body['staffId'];
        final password = body['password'];
        if (staffId == 'test' && password == 'password') {
          return {'success': true, 'message': 'OTP sent successfully'};
        } else {
          return {'success': false, 'message': 'Invalid credentials'};
        }
      case '/adminauth/auth/verify':
        final otp = body['otp'];
        if (otp == '1234') {
          return {'success': true, 'token': 'mock-jwt-token-string'};
        } else {
          return {'success': false, 'message': 'Invalid OTP'};
        }
      default:
        throw Exception('Mock POST handler not implemented for $url');
    }
  }

  Future<Map<String, dynamic>> _handleMockPut(
    String url,
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return {'status': 'success', 'message': 'PUT request was mocked'};
  }

  Future<Map<String, dynamic>> _handleMockDelete(String url) async {
    await Future.delayed(const Duration(seconds: 1));
    return {'status': 'success', 'message': 'DELETE request was mocked'};
  }
}
