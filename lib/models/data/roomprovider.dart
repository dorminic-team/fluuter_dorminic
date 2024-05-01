import 'package:flutter/material.dart';

class RoomProvider with ChangeNotifier {
  List<String> _roomNumbers = [];

  void saveRoomNumbers(List<String> roomNumbers) {
    _roomNumbers = roomNumbers;
    notifyListeners();
  }

  void logout() {
    _roomNumbers.clear(); // Clear the list of room numbers
    // Add any other reset logic here if needed
    notifyListeners();
  }

  List<String> get roomNumbers => _roomNumbers;
}
