import '../../../../services/api_service.dart';

class InspectionRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getInspection(String inspectionId) async {
    try {
      final response = await _apiService.get('/inspection/$inspectionId');
      return response;
    } catch (e) {
      throw Exception('Failed to get inspection: $e');
    }
  }
}
