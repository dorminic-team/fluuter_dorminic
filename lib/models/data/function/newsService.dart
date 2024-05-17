import 'dart:convert';
import 'package:dorminic_co/models/utils/http/http_client.dart'; // Make sure the path is correct

class NewsService {
  final APIClient apiClient = APIClient();

  Future<Map<String, dynamic>> fetchData(String orgCode) async {
    try {
      var response = await apiClient.fetchAnnouncements(orgCode);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        return {
          'newsData': data,
        };
      } else {
        throw Exception('Failed to load News data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
