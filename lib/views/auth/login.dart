import 'dart:convert';

import 'package:dorminic_co/main.dart';
import 'package:dorminic_co/models/data/authprovider.dart';
import 'package:dorminic_co/models/data/organizationprovider.dart';
import 'package:dorminic_co/models/data/roomprovider.dart';
import 'package:dorminic_co/models/utils/constants/assetpath.dart';
import 'package:dorminic_co/models/utils/constants/sizes.dart';
import 'package:dorminic_co/models/utils/constants/text_provider.dart';
import 'package:dorminic_co/models/utils/device/app_spacing.dart';
import 'package:dorminic_co/models/utils/helpers/helper_functions.dart';
import 'package:dorminic_co/models/utils/helpers/passwordvisibilitytoggle.dart';
import 'package:dorminic_co/models/utils/http/http_client.dart';
import 'package:dorminic_co/views/auth/signup.dart';
import 'package:dorminic_co/views/main/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacingStyles.paddingWithAppBarHeight,
          child: Column(
            children: [
              //Logo, Title, and Subtitle Go heres,
              LoginHeader(dark: dark),

              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          height: 150,
          image: AssetImage(
              dark ? AssetsPath.darkAppLogo : AssetsPath.lightAppLogo),
        ),
        Text(
          TextsProvider.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          TextsProvider.loginSubTitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.lg),
      ],
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final APIClient apiClient = APIClient();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoggedIn = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _login() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    try {
      var response = await apiClient.loginUser(username, password);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        String? orgCode = responseData['userData']['org_code'];
        String? uuid = responseData['userData']['userId'];
        AuthProvider authProvider =
            Provider.of<AuthProvider>(context, listen: false);
        authProvider.saveLoginDetails(responseData);
        String? token = responseData['token'];

        if (orgCode != null && orgCode.isNotEmpty) {
          var orgResponse = await apiClient.fetchOrganizationDetails(orgCode);
          if (orgResponse.statusCode == 200) {
            if (token != null && token.isNotEmpty) {
              const storage = FlutterSecureStorage();
              await storage.write(key: 'auth_token', value: token);

              setState(() {
                isLoggedIn = true;
              });

              var orgResponseData = jsonDecode(orgResponse.body);
              OrganizationProvider organizationProvider =
                  Provider.of<OrganizationProvider>(context, listen: false);
              organizationProvider.saveOrganizationDetails(orgResponseData);

              try {
                var roomResponse =
                    await apiClient.fetchRoomDetails(orgCode, uuid!);
                if (roomResponse.statusCode == 200) {
                  var roomResponseData = jsonDecode(roomResponse.body);
                  List<dynamic> roomsList = roomResponseData['room_number'];
                  List<String> roomNumbers = roomsList
                      .map((room) => room['room_number'].toString())
                      .toList();
                  RoomProvider roomProvider =
                      Provider.of<RoomProvider>(context, listen: false);
                  roomProvider.saveRoomNumbers(roomNumbers);
                  // Process room data here as needed
                  Get.offAll(const NavBar());
                } else {
                  Get.snackbar('Error', 'Failed to fetch room details');
                }
              } catch (e) {// Log the error message
                Get.snackbar('Error',
                    'An error occurred while fetching room details');
              }

              // Navigate to the HomeScreen or perform any other action
            } else {
              Get.snackbar('Error', 'Invalid token received');
            }
          } else {
            Get.snackbar('Error', 'Failed to fetch organization details');
          }
        } else {
          Get.snackbar('Error', 'Contact your accommodation\'s administrator');
        }
      } else {
        Get.snackbar('Error', 'Invalid username or password');
      }
    } catch (e) {
      // Handle network or other exceptions
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceBtwItems),
        child: Column(
          children: [
            //--Email
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TextsProvider.email,
                //labelStyle: TextStyle(fontSize: 16)
              ),
            ),

            const SizedBox(
              height: AppSizes.spaceBtwInputFields,
            ),

            //--password
            TextFormField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: 'Password',
                suffixIcon: PasswordVisibilityToggle(
                  obscureText: _obscurePassword,
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),

            const SizedBox(
              height: AppSizes.sm * 0.5,
            ),

            //--Remeber me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //--Forget Password
                TextButton(
                    onPressed: () => Get.to(()),
                    child: const Text(
                      TextsProvider.forgetPassword,
                    )),
              ],
            ),

            const SizedBox(
              height: AppSizes.spaceBtwSections,
            ),

            //--Signin Btn
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                child: const Text(TextsProvider.signIn),
              ),
            ),
            const SizedBox(
              height: AppSizes.spaceBtwItems,
            ),

            //--Signup Btn
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(const SignupScreen()),
                child: const Text(TextsProvider.createAccount),
              ),
            ),
            //const SizedBox(height: AppSizes.spaceBtwSections,),
          ],
        ),
      ),
    );
  }
}
