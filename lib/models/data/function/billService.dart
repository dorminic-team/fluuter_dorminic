import 'dart:convert';
import 'package:dorminic_co/models/utils/http/http_client.dart';

class BillService {
  final APIClient apiClient = APIClient();
  final String baseUrl = 'your_base_url'; // Replace 'your_base_url' with your actual base URL

  Future<Map<String, dynamic>> fetchBills(String orgCode, String userId) async {
    try {
      var response = await apiClient.fetchBillsService(orgCode,userId);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        List<Map<String, dynamic>> unpaidBills = [];
        List<Map<String, dynamic>> paidBills = [];

        for (var bill in data) {
          if (bill['is_paid'] == 'yes') {
            paidBills.add(bill);
          } else {
            unpaidBills.add(bill);
          }
        }

        return {
          'unpaidBills': unpaidBills,
          'paidBills': paidBills,
        };
      } else {
        throw Exception('Failed to fetch bills');
      }
    } catch (e) {
      throw Exception('Error fetching bills: $e');
    }
  }
}
