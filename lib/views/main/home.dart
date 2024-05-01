import 'dart:convert';
import 'package:dorminic_co/models/widgets/path_to_payment_page/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:dorminic_co/models/data/authprovider.dart';
import 'package:dorminic_co/models/data/organizationprovider.dart';
import 'package:dorminic_co/models/data/roomprovider.dart';
import 'package:dorminic_co/models/utils/constants/colors.dart';
import 'package:dorminic_co/models/utils/constants/sizes.dart';
import 'package:dorminic_co/models/utils/helpers/helper_functions.dart';
import 'package:dorminic_co/models/utils/http/http_client.dart';

double totalBill = 0.0;
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final darkMode = AppHelperFunctions.isDarkMode(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final orgProvider = Provider.of<OrganizationProvider>(context);
    final roomProvider = Provider.of<RoomProvider>(context);
    List<String> roomNumbers = roomProvider.roomNumbers;

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: darkMode
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(20, 30, 48, 1), // RGB(20, 30, 48)
                    Color.fromRGBO(0, 0, 0, 1), // RGB(36, 59, 85)
                  ],
                  stops: [
                    0.112,
                    0.411
                  ], // Corresponding to the gradient stops in percentage
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 255, 226, 226), // RGB(20, 30, 48)
                    Color.fromRGBO(255, 255, 255, 1), // RGB(36, 59, 85)
                  ],
                  stops: [
                    0.112,
                    0.411
                  ], // Corresponding to the gradient stops in percentage
                ),
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: AppSizes.appBarHeight),
                  child: Row(
                    children: [
                      const Text('Profile'),
                      const SizedBox(width: AppSizes.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${authProvider.userData!['firstname']} ${authProvider.userData!['lastname']}',
                            style: TextStyle(
                              color:
                                  darkMode ? AppColors.white : AppColors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${orgProvider.organization!['name']}',
                            style: TextStyle(
                              color:
                                  darkMode ? AppColors.white : AppColors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.spaceBtwSections),
                Text(
                  'Yuhuu, Your Summary \nis going here!',
                  style: TextStyle(
                    color: darkMode ? AppColors.white : AppColors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceBtwItems),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: roomNumbers.length,
                  itemBuilder: (BuildContext context, int index) {
                    String roomNumber = roomNumbers[index];
                    return Container(
                      height: 180,
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 16, left: 16, bottom: 16, right: 0),
                        decoration: BoxDecoration(
                          color: darkMode
                              ? AppColors.darkContainer.withOpacity(0.5)
                              : AppColors.darkContainer.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(
                              20.0), // Set border radius here
                        ),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'To Pay',
                              style: TextStyle(
                                color: darkMode
                                    ? AppColors.white
                                    : AppColors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                                height: AppSizes.spaceBtwInputFields),
                            Text(
                              'Room $roomNumber',
                              style: TextStyle(
                                color: darkMode
                                    ? AppColors.darkGrey
                                    : AppColors.darkerGrey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FutureBuilder<double>(
                                  future: startFetchBills(
                                    '${authProvider.userData!['org_code']}',
                                    '${authProvider.userData!['userId']}',
                                  ),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else {
                                      totalBill = snapshot.data ?? 0.0;
                                      
                                      return Text(
                                        'THB ${totalBill.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: darkMode
                                              ? AppColors.white
                                              : AppColors.black,
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    handlePayment(context,
                                        totalBill); // Pass totalBill to handlePayment function
                                  },
                                  icon: const Icon(
                                    Icons.arrow_circle_right,
                                    size: 40,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<double> startFetchBills(String orgCode, String userId) async {
  final APIClient apiClient = APIClient();
  double totalFee = 0.0; // Initialize totalFee outside the try block

  try {
    var response = await apiClient.fetchBills(orgCode, userId);
    if (response.statusCode == 200) {
      // Bills fetched successfully
      var jsonResponse = jsonDecode(response.body);
      int isPaid = jsonResponse.isNotEmpty ? jsonResponse[0]["isPaid"] : 0;
      if (isPaid == 0) {
        double waterFee = jsonResponse.isNotEmpty
            ? double.parse(jsonResponse[0]["water_fee"])
            : 0.0;
        double electricFee = jsonResponse.isNotEmpty
            ? double.parse(jsonResponse[0]["electric_fee"])
            : 0.0;
        double rentalFee = jsonResponse.isNotEmpty
            ? double.parse(jsonResponse[0]["rental_fee"])
            : 0.0;
        totalFee = waterFee + electricFee + rentalFee; // Update totalFee
      }
      // Handle jsonResponse here (e.g., update UI with bills data)
    } else {
      // Handle error response (e.g., show error message)
      print('Failed to fetch bills: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network or other errors
    print('Error fetching bills: $e');
  }

  return totalFee; // Return totalFee
}

void handlePayment(BuildContext context, double totalBill) {
  print('Total Bill in PaymentPage: $totalBill');
  // Navigate to PaymentPage and pass totalBill
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PaymentPage(totalBill: totalBill),
    ),
  );
}

