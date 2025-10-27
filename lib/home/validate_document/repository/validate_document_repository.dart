import '../../../../services/api_service.dart';

class ValidateDocumentRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> validateDocument(String documentNumber) async {
    try {
      // This will be mocked by the ApiService
      final response = await _apiService.get(
        '/validate_document/$documentNumber',
      );
      return response;
    } catch (e) {
      throw Exception('Failed to validate document: $e');
    }
  }
}
