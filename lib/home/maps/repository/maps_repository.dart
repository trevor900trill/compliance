import '../../../../services/api_service.dart';

class MapsRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getMapData(String mapId) async {
    try {
      final response = await _apiService.get('/maps/$mapId');
      return response;
    } catch (e) {
      throw Exception('Failed to get map data: $e');
    }
  }
}
