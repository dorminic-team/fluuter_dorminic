import 'dart:convert';
import 'package:dorminic_co/models/data/annoucementprovider.dart';
import 'package:http/http.dart' as http;

class APIClient {
  static final APIClient _singleton = APIClient._internal();

  factory APIClient() {
    return _singleton;
  }

  APIClient._internal();

  final String baseUrl =
      //'https://dorminic-express-server-7zemj3wqeq-de.a.run.app';
      'http://192.168.1.199:3000';
  http.Client client = http.Client();

  // Example method for making API requests

  Future<http.Response> loginUser(String username, String password) async {
    var url = Uri.parse('$baseUrl/api/login');
    try {
      var response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      return response;
    } catch (e) {
      rethrow; // Rethrow the error to propagate it further if needed
    }
  }

  Future<http.Response> fetchMaintenanceService(String orgCode) async {
    var url = Uri.parse('$baseUrl/api/maintenance/$orgCode'); // Replace with your actual URL
    try {
      var response = await client.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createMaintenance(String orgCode, String title, String description/*, String informantId*/) async {
    final url = Uri.parse('$baseUrl/api/maintenance');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'org_code': orgCode,
          'title': title,
          'description': description,
          'is_fixed': 'no',
        }),
      );
    } catch (e) {
      // Handle exception
      rethrow;
    }
  }


  Future<http.Response> fetchOrganizationDetails(String orgCode) async {
    var url = Uri.parse('$baseUrl/user/organization/getdetails');

    try {
      var response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'org_code': orgCode}),
      );
      return response;
    } catch (e) {
      rethrow; // Rethrow the error to propagate it further if needed
    }
  }

  Future<http.Response> fetchRoomDetails(
      String orgCode, String tenantId) async {
    var url = Uri.parse('$baseUrl/user/room/getdetails');

    try {
      var response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'org_code': orgCode, 'tenant_id': tenantId}),
      );
      return response;
    } catch (e) {
      rethrow; // Rethrow the error to propagate it further if needed
    }
  }

  Future<http.Response> fetchBillsService(String orgCode, String userId) async {
    var url = Uri.parse('$baseUrl/api/bills/customer_id/$userId?org_code=$orgCode');

    try {
      var response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      rethrow; // Rethrow the error to propagate it further if needed
    }
  }

  Future<http.Response> registerUser({
    required String username,
    required String password,
    required String firstname,
    required String lastname,
    required String role,
  }) async {
    var url = Uri.parse('$baseUrl/register');
    try {
      var response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'firstname': firstname,
          'lastname': lastname,
          'role': role,
        }),
      );
      return response;
    } catch (e) {
      rethrow; // Rethrow the error to propagate it further if needed
    }
  }

  Future<List<Announcement>> fetchAnnouncements(String orgCode) async {
    var url = Uri.parse('$baseUrl/announcements?org_code=$orgCode');

    try {
      var response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> parsedJson = jsonDecode(response.body);
        return parsedJson.map((json) => Announcement.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load announcements');
      }
    } catch (e) {
      throw Exception('Error fetching announcements: $e');
    }
  }
}
