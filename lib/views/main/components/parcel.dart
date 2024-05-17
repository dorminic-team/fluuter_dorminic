import 'package:dorminic_co/main.dart';
import 'package:dorminic_co/models/data/function/parcelService.dart';
import 'package:dorminic_co/models/utils/constants/sizes.dart';
import 'package:dorminic_co/models/utils/http/http_client.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../../models/data/userData/userData.dart';

class Parcel extends StatefulWidget {
  const Parcel({super.key});

  @override
  State<Parcel> createState() => _ParcelState();
}

class _ParcelState extends State<Parcel> {
  late Future<Map<String, dynamic>> parcelDataFuture;
  late Future<String> orgCodeFuture;
  late Future<String> userIdFuture;
  final APIClient apiClient = APIClient();
  late String userId;

  @override
  void initState() {
    super.initState();
    orgCodeFuture = _fetchOrgCode();
    _fetchUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
  }

  Future<String> _fetchOrgCode() async {
    UserData userData = UserData();
    Map<String, dynamic> user = await userData.getUserData();
    return user['org_code'] ?? '';
  }

  Future<String> _fetchUserId() async {
    UserData userData = UserData();
    Map<String, dynamic> user = await userData.getUserData();
    return user['userId'] ?? '';
  }

  Future<Map<String, dynamic>> _fetchData(String orgCode, String userId) async {
    final ParcelService parcelService = ParcelService();
    return await parcelService.fetchData(orgCode, userId);
  }

  Future<void> _refreshData() async {
    final orgCode = await _fetchOrgCode();
    final userId = await _fetchUserId();
    setState(() {
      parcelDataFuture = _fetchData(orgCode, userId);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Scaffold(
        body: FutureBuilder<String>(
          future: orgCodeFuture,
          builder: (context, orgCodeSnapshot) {
            if (orgCodeSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (orgCodeSnapshot.hasError) {
              return Center(child: Text('Error: ${orgCodeSnapshot.error}'));
            } else if (!orgCodeSnapshot.hasData ||
                orgCodeSnapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No organization code available'));
            } else {
              final orgCode = orgCodeSnapshot.data!;
              parcelDataFuture = _fetchData(orgCode, userId);

              return FutureBuilder<Map<String, dynamic>>(
                future: parcelDataFuture,
                builder: (context, parcelSnapshot) {
                  if (parcelSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (parcelSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${parcelSnapshot.error}'));
                  } else if (!parcelSnapshot.hasData ||
                      parcelSnapshot.data!.isEmpty) {
                    return const Center(child: Text('No parcel available'));
                  } else {
                    final parcelItems =
                        parcelSnapshot.data!['parcelData'] as List<dynamic>? ??
                            [];
                    return RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.builder(
                        itemCount: parcelItems.length,
                        itemBuilder: (context, index) {
                          final parcelItem = parcelItems[index];
                          return SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.borderRadiusLg),
                                    border: Border.all(
                                        width: 1.0,
                                        color:
                                            Colors.blueAccent.withOpacity(0.3)),
                                    color: Colors.blueAccent.withOpacity(0.03),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Iconsax.document_text),
                                          const SizedBox(width: 16),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                parcelItem['title'],
                                                style: const TextStyle(
                                                  fontSize: AppSizes.fontSizeLg,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                DateUtil.formatDate(parcelItem['created_at']),
                                                style: const TextStyle(
                                                  fontSize: AppSizes.fontSizeSm,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    width: 0.5))),
                                      ),
                                      const SizedBox(
                                        height: AppSizes.spaceBtwItems,
                                      ),
                                      Text(
                                        parcelItem['description'],
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: AppSizes.fontSizeMd,
                                        ),
                                        softWrap: true,
                                        overflow: TextOverflow
                                            .clip, // or TextOverflow.ellipsis, TextOverflow.fade
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppSizes.spaceBtwItems),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
