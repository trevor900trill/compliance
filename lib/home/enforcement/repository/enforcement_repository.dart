import '../../../../services/api_service.dart';

class EnforcementRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getEnforcement(String enforcementId) async {
    try {
      final response = await _apiService.get('/enforcement/$enforcementId');
      return response;
    } catch (e) {
      throw Exception('Failed to get enforcement: $e');
    }
  }
}
