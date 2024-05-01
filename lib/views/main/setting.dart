import 'package:dorminic_co/models/data/authprovider.dart';
import 'package:dorminic_co/models/data/organizationprovider.dart';
import 'package:dorminic_co/models/data/roomprovider.dart';
import 'package:dorminic_co/views/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../models/utils/constants/sizes.dart';
import '../../models/widgets/appbar.dart';
import '../../models/widgets/curve_edge_widgetsetting.dart';
import '../../models/widgets/section_heading.dart';
import '../../models/widgets/settings_menu_tile.dart';
import '../../models/widgets/user_profile_tile.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// --Header
            CurveEdgeWidgetsetting(
              child: Column(
                children: [
                  /// Appbar
                  CustomAppBar(
                    title: Text(
                      'Account',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: Colors.white),
                    ),
                  ),

                  /// User Profile Card
                  UserProfileTile(
                      onPressed: () => Get.to(() => ())),
                  const SizedBox(
                    height: AppSizes.spaceBtwSections,
                  ),
                ],
              ),
            ),

            /// Body
            Padding(
              padding: const EdgeInsets.all(AppSizes.defaultSpace),
              child: Column(
                children: [
                  /// Account Setting
                  /*const SectionHeading(
                      title: 'Account Setting', showActionButton: false),
                  const SizedBox(height: AppSizes.spaceBtwItems),

                  SettingsMenuTile(
                      icon: Iconsax.house,
                      title: 'Account',
                      subTitle: 'Set your account',/*onTap: () => Get.to(() => const ProfileScreen()),*/),
                  SettingsMenuTile(
                      icon: Iconsax.notification,
                      title: 'Notification',
                      subTitle: 'Set any kind of notification message',onTap: () => Get.to(() => /*const NotificationScreen*/()),),
                  SettingsMenuTile(
                      icon: Iconsax.security_card,
                      title: 'Account Privacy',
                      subTitle: 'Manage data usage and connected accounts',onTap: () => Get.to(() => /*const PrivacyScreen*/())),

                  const SizedBox(height: AppSizes.spaceBtwSections),

                  const SectionHeading(title: 'App Setting', showActionButton: false),
                  const SizedBox(height: AppSizes.spaceBtwItems),
                  SettingsMenuTile(
                      icon: Iconsax.setting,
                      title: 'Settings',
                      subTitle: 'Set the suitability for use',onTap: () => Get.to(() => /*const SetScreen*/())),*/
                  SettingsMenuTile(
                      icon: Iconsax.logout,
                      title: 'Sign out',
                      subTitle:
                          'Sign out from Dorminic.co', 
                      onTap: () => _showLogoutConfirmation(context),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void _signOut(BuildContext context) async{
  // Clear authentication token
  Provider.of<AuthProvider>(context, listen: false).logout();

  // Reset other state if needed, such as organization and room data
  Provider.of<OrganizationProvider>(context, listen: false).logout();
  Provider.of<RoomProvider>(context, listen: false).logout();
  const storage = FlutterSecureStorage();
  await storage.delete(key: 'auth_token');

  // Navigate to the login screen or any other desired screen
  Get.offAll(const LoginScreen());
}

void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => _signOut(context),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }