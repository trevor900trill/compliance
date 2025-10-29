import '../../../services/api_service.dart';

class CustomerManagementRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> searchCustomer(
    String idType,
    String idNumber,
  ) async {
    try {
      final response = await _apiService.post('/api/accounts', {
        'id_type': idType,
        'id_number': idNumber,
      });
      return response;
    } catch (e) {
      throw Exception('Failed to search for customer: $e');
    }
  }

  Future<Map<String, dynamic>> createCustomer(
      Map<String, dynamic> customerData) async {
    try {
      final response = await _apiService.post('/api/accounts', customerData);
      return response;
    } catch (e) {
      throw Exception('Failed to create customer: $e');
    }
  }
}
