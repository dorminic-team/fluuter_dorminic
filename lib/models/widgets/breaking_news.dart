
import 'package:flutter/material.dart';
import 'path_to_payment_page/payment_page.dart'; // Adjust the path as per your project structure

// Rest of your code...

class Bill {
  final double totalAmount;
  final DateTime dueDate;
  bool isPaid;

  Bill({
    required this.totalAmount,
    required this.dueDate,
    this.isPaid = false,
  });
}

class BillsPage extends StatefulWidget {
  const BillsPage({Key? key}) : super(key: key);

  @override
  _BillsPageState createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  List<Bill> _bills = [
    Bill(totalAmount: 950.0, dueDate: DateTime(2024, 6, 30), isPaid: false),
    Bill(totalAmount: 1050.0, dueDate: DateTime(2024, 5, 1), isPaid: false),
    Bill(totalAmount: 1050.0, dueDate: DateTime(2024, 4, 1), isPaid: false),
    Bill(totalAmount: 1500.0, dueDate: DateTime(2024, 5, 1), isPaid: true),
  ].where((bill) => !bill.isPaid).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bills & Payments',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total monthly amount to pay',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      '${_bills.fold(0.0, (previousValue, bill) => previousValue + bill.totalAmount).toStringAsFixed(2)} Bath',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                       onPressed: () {
},
                        child: Text('Pay Now',
                            style: TextStyle(
                              fontSize: 16.0,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Payment history',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: _bills.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10.0), // Add bottom padding here
                    child: Card(
                      elevation: 4.0,
                      child: ExpansionTile(
                        title: Text(
                            'Total Amount: ${_bills[index].totalAmount.toString()} Bath'),
                        subtitle: Text(
                            'Due Date: ${_bills[index].dueDate.month}/${_bills[index].dueDate.year} - Status: ${_bills[index].isPaid ? 'Paid' : 'Unpaid'}'),
                        children: [
                          ListTile(
                            title: Text('Electricity Bill: 500 Bath'),
                          ),
                          ListTile(
                            title: Text('Water Bill: 300 Bath'),
                          ),
                          ListTile(
                            title: Text('Rent: 150 Bath'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
