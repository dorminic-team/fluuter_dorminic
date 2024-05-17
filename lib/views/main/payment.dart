import 'package:dorminic_co/models/data/function/billService.dart';
import 'package:dorminic_co/models/data/userData/userData.dart';
import 'package:dorminic_co/models/utils/constants/colors.dart';
import 'package:dorminic_co/models/utils/constants/sizes.dart';
import 'package:dorminic_co/models/utils/helpers/helper_functions.dart';
import 'package:dorminic_co/models/widgets/glassbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late Future<Map<String, dynamic>> billData;
  late Future<String> orgCodeFuture;
  late Future<String> userIdFuture;
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

  Future<Map<String, dynamic>> _fetchData() async {
    final BillService billService = BillService();
    return await billService.fetchBills(
        userData['org_code'], userData['userId']);
  }

  Future<void> _refreshData() async {
    setState(() {
      billData = _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Payment',
            style: TextStyle(fontSize: 24),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(children: [
              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),
              GlassBox(
                width: double.infinity,
                height: 200.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Outstanding Balance',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: AppSizes.fontSizeMd,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text(
                                'THB ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.5)),
                              ),
                              const Text(
                                '1000',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text('Due date: '), Text('May 15, 2024')],
                        ),
                      ]),
                ),
              ),
              const SizedBox(
                height: AppSizes.spaceBtwSections,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    'History',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: AppSizes.fontSizeLg,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusLg),
                      color: AppColors.greyblacker,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSizes.borderRadiusMd),
                            color: AppColors.amber400,
                            border:
                                Border.all(width: 1, color: AppColors.amber400),
                          ),
                          child: const Icon(Iconsax.clock5),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'title',
                              style: TextStyle(
                                fontSize: AppSizes.fontSizeLg,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'description',
                              style: TextStyle(
                                fontSize: AppSizes.fontSizeSm,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceBtwItems),
                ],
              ),
            ]),
          ),
        ),
        floatingActionButton: Container(
          width: 150.0, // Custom width
          height: 56.0, // Default height for FloatingActionButton
          child: RawMaterialButton(
            onPressed: () {
              // Define the action that will be taken when the button is pressed
              print('Custom FAB pressed');
            },
            fillColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
            elevation: 6.0,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.card, color: Colors.white),
                SizedBox(width: 8.0),
                Text(
                  'Pay Now',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.fontSizeLg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
