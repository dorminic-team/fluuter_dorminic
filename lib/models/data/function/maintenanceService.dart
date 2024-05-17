import 'dart:convert';
import 'package:dorminic_co/models/utils/http/http_client.dart'; // Make sure the path is correct

class MaintenanceService {
  final APIClient apiClient = APIClient();

  Future<Map<String, dynamic>> fetchData(String orgCode) async {
    try {
      var response = await apiClient.fetchMaintenanceService(orgCode);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        List<Map<String, dynamic>> pendingTasks = [];
        List<Map<String, dynamic>> doneTasks = [];

        for (var task in data) {
          if (task['is_fixed'] == 'yes') {
            doneTasks.add(task);
          } else {
            pendingTasks.add(task);
          }
        }

        return {
          'pendingTasks': pendingTasks,
          'doneTasks': doneTasks,
        };
      } else {
        throw Exception('Failed to load maintenance data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
