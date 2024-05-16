import 'dart:convert';
import 'dart:core'; // Import 'dart:core' for basic types like List, Future

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dorminic_co/models/data/annoucementprovider.dart'; // Import Announcement and fetchAnnouncements
import 'package:dorminic_co/models/data/authprovider.dart'; // Import AuthProvider
import 'package:dorminic_co/models/widgets/path_to_payment_page/payment_page.dart'; // Import PaymentPage
import 'package:dorminic_co/models/widgets/Tabbar.dart'; // Import Tabitem
import '../../models/utils/constants/colors.dart'; // Import AppColors
import '../../models/utils/helpers/helper_functions.dart'; // Import AppHelperFunctions
import '../../models/utils/http/http_client.dart'; // Import http client

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final darkMode = AppHelperFunctions.isDarkMode(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return DefaultTabController(
      length: 2, // Updated to 2 tabs
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Menu',
              style: TextStyle(fontSize: 24),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: darkMode
                        ? AppColors.darkContainer.withOpacity(0.5)
                        : AppColors.darkContainer.withOpacity(0.07),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelColor: darkMode ? Colors.white : Colors.black,
                    unselectedLabelColor:
                        darkMode ? Colors.white : Colors.black,
                    tabs: [
                      Tabitem(titile: 'News', count: 0),
                      Tabitem(titile: 'Parcel', count: 0), // Removed 'Bills' tab
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: FutureBuilder<List<Announcement>>(
                  future: APIClient().fetchAnnouncements(
                      '${authProvider.userData?['org_code'] ?? 'Unavalable'}'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final announcements = snapshot.data!;
                      return Scaffold(
                        body: NewsPage(announcements: announcements),
                      );
                    }
                  },
                ),
              ),
              Center(child: Text('Coming Soon')), // Adjusted tab content
            ],
          ),
        ),
      ),
    );
  }
}

class NewsPage extends StatelessWidget {
  final List<Announcement> announcements;

  NewsPage({required this.announcements});

  @override
  Widget build(BuildContext context) {
    final darkMode = AppHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final announcement = announcements[index];
          return NewsItem(
            announcement: announcement,
            darkMode: darkMode,
            onTap: () {
              // Navigate to detailed news page
              // Implement your navigation logic here
            },
          );
        },
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  final Announcement announcement;
  final bool darkMode;
  final VoidCallback onTap;

  NewsItem({
    required this.announcement,
    required this.darkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = darkMode
        ? AppColors.darkContainer.withOpacity(0.5)
        : AppColors.white.withOpacity(0.85);

    return Card(
      color: backgroundColor,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Announcement ID: ${announcement.announcementId}',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 8),
              Text(
                announcement.topic,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                announcement.description,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'Expired: ${announcement.isExpired ? 'Yes' : 'No'}',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Bill {
  final double waterFee;
  final double electricFee;
  final double rentalFee;

  Bill({
    required this.waterFee,
    required this.electricFee,
    required this.rentalFee,
  });
}

class BillsPage extends StatefulWidget {
  const BillsPage({Key? key}) : super(key: key);

  @override
  _BillsPageState createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  List<Bill> _bills = []; // Initialize an empty list of bills

  @override
  void initState() {
    super.initState();
    // Fetch bills data and update _bills list
    _fetchBillsData();
  }

  // Method to fetch bills data
  Future<void> _fetchBillsData() async {
    // Use your fetchBills method here to fetch bills data
    // Example: await authProvider.fetchBillsData();
    // Assuming authProvider.fetchBillsData() returns a Future<List<Bill>>
    // Update _bills list with fetched data
    setState(() {
      _bills = []; // Replace with fetched bills data
    });
  }

  // Calculate the total amount dynamically based on the bills list
  double calculateTotal() {
    double total = 0;
    for (var bill in _bills) {
      total += bill.waterFee + bill.electricFee + bill.rentalFee;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    // Get the auth provider instance using Provider.of
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bills & Payments',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Total monthly amount card
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total monthly amount to pay',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Total: ${calculateTotal().toStringAsFixed(2)}', // Calculate and display the actual total
                      style: TextStyle(fontSize: 32.0),
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentPage(
                                totalBill: calculateTotal(), // Pass the actual total bill amount here
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Pay Now',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            // Bill details section
            Text(
              'Detail',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: _bills.length,
                itemBuilder: (context, index) {
                  // Use the bill data to populate the UI
                  final Bill bill = _bills[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Card(
                      elevation: 4.0,
                      child: ExpansionTile(
                        title: Text('Total Amount: ${bill.waterFee + bill.electricFee + bill.rentalFee} Bath'),
                        subtitle: Text('Due Date: '), // Add due date here
                        children: [
                          ListTile(
                            title: Text('Electricity Bill: ${bill.electricFee} Bath'),
                          ),
                          ListTile(
                            title: Text('Water Bill: ${bill.waterFee} Bath'),
                          ),
                          ListTile(
                            title: Text('Rent: ${bill.rentalFee} Bath'),
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