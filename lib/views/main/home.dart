import 'dart:convert';
import 'package:dorminic_co/models/data/userData/userData.dart';
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
  const HomeScreen({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  Map<String, dynamic> userData = {};
  
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    UserData userDataFetcher = UserData();
    Map<String, dynamic> fetchedData = await userDataFetcher.getUserData();
    setState(() {
      userData = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
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
        )),
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
                            '${userData['firstname'] ?? 'Unknown'} ${userData['lastname'] ?? 'User'}',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${userData['org_name'] ?? 'Unknown'}',
                            style: TextStyle(
                              color: AppColors.white,
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
                    color: AppColors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceBtwItems),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
