import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:dorminic_co/models/data/authprovider.dart';
import 'package:dorminic_co/models/data/organizationprovider.dart';
import 'package:dorminic_co/models/data/userData/userData.dart';
import 'package:dorminic_co/models/utils/constants/colors.dart';

class UserProfileTile extends StatefulWidget {
  const UserProfileTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  _UserProfileTileState createState() => _UserProfileTileState();
}

class _UserProfileTileState extends State<UserProfileTile> {
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        'assets/icons/App-icon.png',
        width: 50,
        height: 50,
      ),
      title: Text(
        '${userData['firstname'] ?? 'Unknown'} ${userData['lastname'] ?? 'User'}',
        style: Theme.of(context).textTheme.headlineSmall!.apply(color: Colors.white),
      ),
      subtitle: Text(
        '${userData['username'] ?? 'Unknown'}',
        style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
      ),
      trailing: IconButton(
        onPressed: widget.onPressed,
        icon: const Icon(Iconsax.edit, color: AppColors.white),
      ),
    );
  }
}
