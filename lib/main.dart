import 'package:dorminic_co/models/data/authprovider.dart';
import 'package:dorminic_co/models/data/bill/billprovider.dart';
import 'package:dorminic_co/models/data/organizationprovider.dart';
import 'package:dorminic_co/models/data/roomprovider.dart';
import 'package:dorminic_co/models/utils/constants/colors.dart';
import 'package:dorminic_co/models/utils/helpers/helper_functions.dart';
import 'package:dorminic_co/models/utils/theme/theme.dart';
import 'package:dorminic_co/views/auth/login.dart';
import 'package:dorminic_co/views/main/chat.dart';
import 'package:dorminic_co/views/main/home.dart';
import 'package:dorminic_co/views/main/maintenance.dart';
import 'package:dorminic_co/views/main/menu.dart';
import 'package:dorminic_co/views/main/payment.dart';
import 'package:dorminic_co/views/main/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const storage = FlutterSecureStorage();
  String? authToken = await storage.read(key: 'auth_token');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrganizationProvider()),
        ChangeNotifierProvider(
          create: (_) => RoomProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BillProvider(),
        )
        // Add other providers as needed
      ],
      child: MyApp(authToken: authToken),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? authToken;
  const MyApp({super.key, required this.authToken});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dorminic.co',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.darkTheme.copyWith(
        useMaterial3: true,
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => Container(
          color: dark ? AppColors.black : AppColors.light,
            child: SafeArea(
                child: GNav(
                  selectedIndex: controller.selectedIndex.value,
                  onTabChange: (index) => controller.selectedIndex.value = index,
                  gap: 8,
                  activeColor: dark ? AppColors.light : AppColors.black,
                  iconSize: 20,
                  duration: const Duration(milliseconds: 400),
                  color: dark ? AppColors.light.withOpacity(0.5) : AppColors.black.withOpacity(0.5),
                  tabs: const [
                    GButton(
                      icon: Iconsax.home,
                    ),
                    GButton(
                      icon: Iconsax.wallet,
                    ),
                    GButton(
                      icon: Iconsax.information,
                    ),
                    GButton(
                      icon: Iconsax.user,
                    ),
                  ],
                ),
            ),
          ),
        ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const HomeScreen(),
    const Payment(),
    const MaintenanceScreen(),
    const SettingScreen()
  ];
}
