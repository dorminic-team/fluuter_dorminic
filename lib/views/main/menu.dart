import 'dart:convert';
import 'dart:core'; // Import 'dart:core' for basic types like List, Future

import 'package:dorminic_co/views/main/components/parcel.dart';
import 'package:dorminic_co/views/main/components/news.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Announcement and fetchAnnouncements
import 'package:dorminic_co/models/data/authprovider.dart'; // Import AuthProvider
import 'package:dorminic_co/models/widgets/path_to_payment_page/payment_page.dart'; // Import PaymentPage
import 'package:dorminic_co/models/widgets/Tabbar.dart'; // Import Tabitem
import '../../models/data/userData/userData.dart';
import '../../models/utils/constants/colors.dart'; // Import AppColors
import '../../models/utils/helpers/helper_functions.dart'; // Import AppHelperFunctions
import '../../models/utils/http/http_client.dart'; // Import http client

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<MenuScreen> {
  Map<String, dynamic> userData = {};
  String orgCode = ''; // Define orgCode here
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
      orgCode = userData['org_code'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = AppHelperFunctions.isDarkMode(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return DefaultTabController(
      length: 2, // Updated to 2 tabs
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
                    indicator: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelColor: darkMode ? Colors.white : Colors.black,
                    unselectedLabelColor:
                        darkMode ? Colors.white : Colors.black,
                    tabs: const [
                      Tabitem(titile: 'News', count: 0),
                      Tabitem(
                          titile: 'Parcel', count: 0), // Removed 'Bills' tab
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              Center(
                child: News(),
              ),
              Center(
                child: Parcel(),
              ), // Adjusted tab content
            ],
          ),
        ),
      ),
    );
  }
}
