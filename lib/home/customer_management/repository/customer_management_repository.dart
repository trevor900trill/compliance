import '../../../services/api_service.dart';

class CustomerManagementRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> searchIndividual(String idNumber) async {
    try {
      final response = await _apiService.get('/adminauth/external/user/kra/id/$idNumber');
      return response;
    } catch (e) {
      throw Exception('Failed to search individual: $e');
    }
  }

  Future<Map<String, dynamic>> searchBusiness(String kraPin) async {
    try {
      final response = await _apiService.get('/adminauth/external/user/kra/real/pin/$kraPin');
      return response;
    } catch (e) {
      throw Exception('Failed to search business: $e');
    }
  }

  Future<Map<String, dynamic>> registerIndividual(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/auth/individual/register', data);
      return response;
    } catch (e) {
      throw Exception('Failed to register individual: $e');
    }
  }
}
