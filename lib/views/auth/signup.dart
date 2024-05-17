import 'package:dorminic_co/models/utils/http/http_client.dart';
import 'package:dorminic_co/views/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/utils/constants/assetpath.dart';
import '../../models/utils/constants/colors.dart';
import '../../models/utils/constants/sizes.dart';
import '../../models/utils/constants/text_provider.dart';
import '../../models/utils/helpers/helper_functions.dart';
import '../../models/utils/helpers/passwordvisibilitytoggle.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SignupHeader(dark: dark),
            const SizedBox(height: AppSizes.defaultSpace),
            const SignupForm(),
          ],
        ),
      ),
    );
  }
}

class SignupHeader extends StatelessWidget {
  const SignupHeader({
    Key? key,
    required this.dark,
  }) : super(key: key);

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          height: 100,
          image: AssetImage(dark ? AssetsPath.darkAppLogo : AssetsPath.lightAppLogo),
        ),
        Text(
          TextsProvider.signupTitle,
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key});

  @override
  _SignupFormState createState() => _SignupFormState();
}


class _SignupFormState extends State<SignupForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _registerUser() async {
  // Get user input from form fields
  String username = usernameController.text.trim();
  String email = emailController.text.trim();
  String password = passwordController.text.trim();
  String firstName = firstNameController.text.trim();
  String lastName = lastNameController.text.trim();
  String role = 'USER'; // or 'ADMIN', 'MODERATOR', etc. depending on your logic

  try {
    var response = await APIClient().registerUser(
      username: username,
      password: password,
      email: email,
      firstname: firstName,
      lastname: lastName,
      role: role,
    );
      // Registration successful
      Get.snackbar('Success', 'User registered successfully');
      Get.offAll(const LoginScreen());
  } catch (e) {
    // Handle network or other exceptions
    Get.snackbar('Error', 'An error occurred. Please try again later.');
  }
}


  @override
  void dispose() {
    // Dispose controllers when not needed to free up resources
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);

    return Form(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.personalcard),
                    labelText: TextsProvider.firstName,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.personalcard),
                    labelText: TextsProvider.lastName,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.user_edit),
              labelText: TextsProvider.username,
            ),
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.direct_right),
              labelText: TextsProvider.email,
            ),
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),
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
          const SizedBox(height: AppSizes.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                softWrap: true,
                maxLines: 2,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${TextsProvider.iAgreeTo} ',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    TextSpan(
                      text: TextsProvider.privacyPolicy,
                      style: Theme.of(context).textTheme.bodyText2!.apply(
                            color: dark ? AppColors.white : AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                    TextSpan(
                      text: ' ${TextsProvider.and} ',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    TextSpan(
                      text: '${TextsProvider.termsOfUse}.',
                      style: Theme.of(context).textTheme.bodyText2!.apply(
                            color: dark ? AppColors.white : AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _registerUser,
              child: const Text(TextsProvider.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}