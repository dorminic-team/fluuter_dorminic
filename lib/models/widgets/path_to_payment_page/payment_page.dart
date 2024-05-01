import 'package:dorminic_co/models/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final double totalBill;

  const PaymentPage({Key? key, required this.totalBill});

  @override
  Widget build(BuildContext context) {
    final darkMode = AppHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios, // Use arrow_back_ios icon
            color: darkMode ? Colors.white : Colors.black, // Set color based on theme
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Total Bill: $totalBill', // Display totalBill here
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Image.network(
              'https://promptpay.io/0813265547/$totalBill.png',
              width: 250, // Adjust the width as needed
              height: 250, // Adjust the height as needed
              fit: BoxFit.contain, // Adjust the fit property as needed
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
