import '../../../services/api_service.dart';

class ValidateDocumentRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> validateDocument(String documentNumber) async {
    try {
      final response = await _apiService.post('/documents/api/search/', {
        'document_number': documentNumber,
        'document_type': 'Appraisal',
      });
      return response;
    } catch (e) {
      throw Exception('Failed to validate document: $e');
    }
  }
}
