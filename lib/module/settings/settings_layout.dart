import 'package:charity/module/auth_screens/login_screen/login_screen.dart';
import 'package:charity/module/settings/about_us_screen.dart';
import 'package:charity/module/settings/complaint_screen.dart';
import 'package:charity/module/settings/edit_profile_screen.dart';
import 'package:charity/module/settings/profile_screen.dart';
import 'package:charity/shared/components/components.dart';
import 'package:charity/shared/cubit/charity_cubit.dart';
import 'package:charity/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart'; // Import the Lottie package
import '../../../shared/styles/theme.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = CharityCubit.get(context);
    return BlocConsumer<CharityCubit, CharityState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body:cubit.loadingUserData?Center(child: CircularProgressIndicator(),): Column(
        children: [
          // Profile Header
          _buildProfileHeader(context),
          const SizedBox(height: 20),

          // Settings List
         CacheHelper.getData(key: 'token')==null?
         Expanded(
           child: ListView(
             padding: EdgeInsets.symmetric(horizontal: 16),
             children: [
               _buildSettingsTile(
                 context,
                 icon: Icons.login_outlined,
                 title: 'Login',
                 onTap: () => navigateAndFinish(context,LoginScreen()), // Adjust route
               ),
             ],
           ),
         )
         : Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),

              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () => navigateTo(context, ProfileScreen()), // Adjust route
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.edit,
                  title: 'Edit Profile',
                  onTap: () => navigateTo(context,EditProfileScreen()), // Adjust route
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.report,
                  title: 'Complaint',
                  onTap: () => navigateTo(context,ComplaintScreen()), // Adjust route
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.info,
                  title: 'About Us',
                  onTap: () {
                    cubit.getAboutUs();
                    navigateTo(context, AboutUsScreen());
                  }, // Adjust route
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
);
  }

  Widget _buildProfileHeader(BuildContext context) {
    var cubit = CharityCubit.get(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, kPrimaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          // CircleAvatar with Lottie animation
          Container(
            width: 70,
            height: 70,
            child: CircleAvatar(
              backgroundColor: Colors.transparent, // Ensure transparent background
              child: Lottie.asset('assets/lottie/profile.json',), // Lottie animation as avatar
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CacheHelper.getData(key: 'token')!= null? cubit.userModel.first.name! : 'No Name' ,
                style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                CacheHelper.getData(key: 'token')!= null? cubit.userModel.first.email! :'No Email',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: Icon(icon, color: kPrimaryColor, size: 28),
            title: Text(title, style: TextStyle(fontSize: 18, color: kTextColor)),
            trailing: Icon(Icons.chevron_right, color: kTextColor),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
          ),
          content: Text('Are you sure you want to logout?', style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
              style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
            ),
            ElevatedButton(
              onPressed: () {
                CharityCubit.get(context).logout(context: context);
              },
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        );
      },
    );
  }
}
