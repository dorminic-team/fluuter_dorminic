import 'dart:convert';
import 'package:dorminic_co/models/utils/http/http_client.dart'; // Make sure the path is correct

class ParcelService {
  final APIClient apiClient = APIClient();

  Future<Map<String, dynamic>> fetchData(String orgCode, String userId) async {
    try {
      var response = await apiClient.fetchParcel(orgCode, userId);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        return {
          'parcelData': data,
        };
      } else {
        throw Exception('Failed to load News data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
