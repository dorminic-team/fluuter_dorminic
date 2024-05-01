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
import 'package:dorminic_co/views/main/menu.dart';
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
        ChangeNotifierProvider(create: (_) => RoomProvider(),),
        ChangeNotifierProvider(create: (context) => BillProvider(),)
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
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme.copyWith(useMaterial3: true,),
      darkTheme: AppTheme.darkTheme.copyWith(useMaterial3: true,),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: GNav(
              selectedIndex: controller.selectedIndex.value,
              onTabChange: (index) => controller.selectedIndex.value = index,
              gap: 8,
              activeColor: dark ? AppColors.light : AppColors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              color: dark ? AppColors.light : AppColors.black,
              tabs: const [
                GButton(
                  icon: Iconsax.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Iconsax.menu,
                  text: 'Menu',
                ),
                GButton(
                  icon: Iconsax.user,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),

      body: Obx(() =>controller.screens[controller.selectedIndex.value]),
    );
    
  }
}

class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;
  final screens = [const HomeScreen(), const MenuScreen(), const SettingScreen()];
}
