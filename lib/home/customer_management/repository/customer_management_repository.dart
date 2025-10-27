import '../../../../services/api_service.dart';

class CustomerManagementRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getCustomer(String customerId) async {
    try {
      final response = await _apiService.get('/customer/$customerId');
      return response;
    } catch (e) {
      throw Exception('Failed to get customer: $e');
    }
  }
}
