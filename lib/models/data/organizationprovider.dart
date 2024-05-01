import 'package:flutter/foundation.dart';

class OrganizationProvider with ChangeNotifier {
  List<Map<String, dynamic>>? _organizationData;

  void saveOrganizationDetails(Map<String, dynamic> organizationData) {
    _organizationData = List<Map<String, dynamic>>.from(organizationData['organization']);
    notifyListeners();
  }

  void logout() {
    _organizationData = null;
    // Add any other reset logic here if needed
    notifyListeners();
  }

  Map<String, dynamic>? get organization {
    if (_organizationData != null && _organizationData!.isNotEmpty) {
      return _organizationData![0]; // Return the first item in the list
    } else {
      return null; // Return null if the list is empty or null
    }
  }
}
