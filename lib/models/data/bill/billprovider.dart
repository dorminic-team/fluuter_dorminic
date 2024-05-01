import 'package:flutter/material.dart';

class BillProvider extends ChangeNotifier {
  List<Bill> _bills = [];

  List<Bill> get bills => _bills;

}

class Bill {
  int billId;
  String orgCode;
  double waterFee;
  double electricFee;
  double rentalFee;
  int month;
  int year;
  int isPaid;
  String createdAt;
  String userId;
  String roomNumber;

  Bill({
    required this.billId,
    required this.orgCode,
    required this.waterFee,
    required this.electricFee,
    required this.rentalFee,
    required this.month,
    required this.year,
    required this.isPaid,
    required this.createdAt,
    required this.userId,
    required this.roomNumber,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      billId: json['bill_id'],
      orgCode: json['org_code'],
      waterFee: json['water_fee'].toDouble(),
      electricFee: json['electric_fee'].toDouble(),
      rentalFee: json['rental_fee'].toDouble(),
      month: json['month'],
      year: json['year'],
      isPaid: json['isPaid'],
      createdAt: json['created_at'],
      userId: json['user_id'],
      roomNumber: json['room_number'],
    );
  }
}

