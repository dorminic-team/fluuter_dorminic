import 'package:dorminic_co/main.dart';
import 'package:dorminic_co/models/utils/constants/colors.dart';
import 'package:dorminic_co/models/utils/constants/sizes.dart';
import 'package:dorminic_co/models/utils/http/http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../../models/data/function/newsService.dart';
import '../../../models/data/userData/userData.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  late Future<Map<String, dynamic>> newsDataFuture;
  late Future<String> orgCodeFuture;
  final APIClient apiClient = APIClient();
  bool? resultFromMaintenanceForm;

  @override
  void initState() {
    super.initState();
    orgCodeFuture = _fetchOrgCode();
  }

  Future<String> _fetchOrgCode() async {
    UserData userData = UserData();
    Map<String, dynamic> user = await userData.getUserData();
    return user['org_code'] ?? '';
  }

  Future<Map<String, dynamic>> _fetchData(String orgCode) async {
    final NewsService newsService = NewsService();
    return await newsService.fetchData(orgCode);
  }

  Future<void> _refreshData() async {
    final orgCode = await _fetchOrgCode();
    setState(() {
      newsDataFuture = _fetchData(orgCode);
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
              newsDataFuture = _fetchData(orgCode);

              return FutureBuilder<Map<String, dynamic>>(
                future: newsDataFuture,
                builder: (context, newsSnapshot) {
                  if (newsSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (newsSnapshot.hasError) {
                    return Center(child: Text('Error: ${newsSnapshot.error}'));
                  } else if (!newsSnapshot.hasData ||
                      newsSnapshot.data!.isEmpty) {
                    return const Center(child: Text('No news available'));
                  } else {
                    final newsItems =
                        newsSnapshot.data!['newsData'] as List<dynamic>? ?? [];
                    return RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.builder(
                        itemCount: newsItems.length,
                        itemBuilder: (context, index) {
                          final newsItem = newsItems[index];
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
                                                newsItem['title'],
                                                style: const TextStyle(
                                                  fontSize: AppSizes.fontSizeLg,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                DateUtil.formatDate(
                                                    newsItem['created_at']),
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
                                        newsItem['description'],
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
