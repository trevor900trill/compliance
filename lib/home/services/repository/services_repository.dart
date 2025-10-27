import '../../../../services/api_service.dart';

class ServicesRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getServices() async {
    try {
      final response = await _apiService.get('/services');
      return response;
    } catch (e) {
      throw Exception('Failed to get services: $e');
    }
  }
}
