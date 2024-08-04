import 'package:charity/shared/cubit/charity_cubit.dart';
import 'package:flutter/material.dart';
import '../../../shared/styles/theme.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(context),
            const SizedBox(height: 20),

            // Profile Details
            _buildProfileDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(context) {
    var cubit = CharityCubit.get(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, kPrimaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Lottie.asset('assets/lottie/profile.json'), // Lottie animation as avatar
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cubit.userModel.first.name!, // Replace with dynamic user name
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                cubit.userModel.first.email!, // Replace with dynamic email
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context) {
    // Example data - replace with actual user data
    var cubit = CharityCubit.get(context);
    final profileData = {
      'National Number': cubit.userModel.first.idKey!,
      'Name': cubit.userModel.first.name!,
      'Email': cubit.userModel.first.email!,
      'Phone Number': cubit.userModel.first.number!,
      'Address': cubit.userModel.first.address!,
      'Birth Date': cubit.userModel.first.date!,
    };

    return Expanded(
      child: ListView(
        children: profileData.entries.map((entry) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Icon(_getIconForField(entry.key), color: kPrimaryColor),
              title: Text(
                entry.key,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
              ),
              subtitle: Text(
                entry.value,
                style: TextStyle(fontSize: 14, color: kTextColor),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getIconForField(String field) {
    switch (field) {
      case 'National Number':
        return Icons.card_membership;
      case 'Name':
        return Icons.person;
      case 'Email':
        return Icons.email;
      case 'Phone Number':
        return Icons.phone;
      case 'Address':
        return Icons.home;
      case 'Birth Date':
        return Icons.calendar_today;
      default:
        return Icons.info;
    }
  }
}
