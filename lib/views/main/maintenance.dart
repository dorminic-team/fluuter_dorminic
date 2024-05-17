import 'package:dorminic_co/models/data/function/maintenanceService.dart';
import 'package:dorminic_co/models/data/userData/userData.dart';
import 'package:dorminic_co/models/utils/http/http_client.dart';
import 'package:dorminic_co/views/main/components/maintenanceForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/utils/constants/colors.dart';
import '../../models/utils/constants/sizes.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  MaintenanceScreenState createState() => MaintenanceScreenState();
}

class MaintenanceScreenState extends State<MaintenanceScreen> {
  late Future<Map<String, dynamic>> maintenanceData;
  late Future<String> orgCodeFuture;
  final APIClient apiClient = APIClient();
  bool? resultFromMaintenanceForm;
  @override
  void initState() {
    super.initState();
    orgCodeFuture = _fetchOrgCode();
    orgCodeFuture.then((orgCode) {
      maintenanceData = _fetchData(orgCode);
    });
  }

  Future<String> _fetchOrgCode() async {
    UserData userData = UserData();
    Map<String, dynamic> user = await userData.getUserData();
    return user['org_code'] ?? '';
  }

  Future<Map<String, dynamic>> _fetchData(String orgCode) async {
    final MaintenanceService maintenanceService = MaintenanceService();
    return await maintenanceService.fetchData(orgCode);
  }

  Future<void> _refreshData() async {
    orgCodeFuture = _fetchOrgCode();
    orgCodeFuture.then((orgCode) {
      setState(() {
        maintenanceData = _fetchData(orgCode);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: orgCodeFuture,
      builder: (context, orgCodeSnapshot) {
        if (orgCodeSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (orgCodeSnapshot.hasError) {
          return Center(child: Text('Error: ${orgCodeSnapshot.error}'));
        } else {
          final orgCode = orgCodeSnapshot.data!;
          return FutureBuilder<Map<String, dynamic>>(
            future: _fetchData(orgCode),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              } else {
                final data = snapshot.data!;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text('Maintenance',
                          style: TextStyle(fontSize: 24)),
                    ),
                    body: RefreshIndicator(
                      onRefresh: _refreshData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
                          child: Column(
                            children: [
                              const SizedBox(height: AppSizes.spaceBtwItems),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    'Pending',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: AppSizes.fontSizeLg,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSizes.spaceBtwItems),
                              ...data['pendingTasks'].map<Widget>((task) {
                                return Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      height: 75,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.borderRadiusLg),
                                        color: AppColors.greyblacker,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppSizes.borderRadiusMd),
                                              color: AppColors.amber400,
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors.amber400),
                                            ),
                                            child: const Icon(Iconsax.clock5),
                                          ),
                                          const SizedBox(width: 16),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                task['title'],
                                                style: const TextStyle(
                                                  fontSize: AppSizes.fontSizeLg,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                task['description'],
                                                style: const TextStyle(
                                                  fontSize: AppSizes.fontSizeSm,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        height: AppSizes.spaceBtwItems),
                                  ],
                                );
                              }).toList(),
                              const SizedBox(height: AppSizes.spaceBtwItems),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    'Done',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: AppSizes.fontSizeLg,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSizes.spaceBtwItems),
                              ...data['doneTasks'].map<Widget>((task) {
                                return Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      height: 75,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.borderRadiusLg),
                                        color: AppColors.greyblacker,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppSizes.borderRadiusMd),
                                              color: AppColors.teal400,
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors.teal400),
                                            ),
                                            child: const Icon(
                                                Iconsax.chart_success),
                                          ),
                                          const SizedBox(width: 16),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                task['title'],
                                                style: const TextStyle(
                                                  fontSize: AppSizes.fontSizeLg,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                task['description'],
                                                style: const TextStyle(
                                                  fontSize: AppSizes.fontSizeSm,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        height: AppSizes.spaceBtwItems),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    floatingActionButton: SizedBox(
                      width: 56.0,
                      height: 56.0,
                      child: RawMaterialButton(
                        onPressed: () async {
                          await Get.to(MaintenanceForm(
                            apiClient: apiClient,
                            orgCode: orgCode,
                          ));
                          if (resultFromMaintenanceForm == true) {
                            _refreshData();
                          }
                        },
                        fillColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200.0),
                        ),
                        elevation: 6.0,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.add, color: Colors.white),
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
