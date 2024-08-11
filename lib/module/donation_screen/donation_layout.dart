import 'dart:math'; // Import to use Random
import 'package:charity/shared/components/components.dart';
import 'package:flutter/material.dart';
import '../../shared/cubit/charity_cubit.dart';
import '../../shared/network/local/cache_helper.dart';
import '../auth_screens/login_screen/login_screen.dart';
import 'campaign/campaigns_page.dart';
import 'previous_donations/previous_donations_page.dart';
import 'request/request_page.dart';

class DonationScreen extends StatefulWidget {
  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    CampaignsPage(),
    RequestsPage(),
    PreviousDonationsPage(),
  ];



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showDonationDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Donate to Fund',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter the amount you want to donate in Syrian Pounds:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Your wallet balance: ${CharityCubit.get(context).walletAmount.toStringAsFixed(2)} SYP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Amount (SYP)',
                    prefixIcon: Icon(Icons.monetization_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount.';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Enter a valid amount greater than zero.';
                    }
                    if (amount > CharityCubit.get(context).walletAmount) {
                      return 'Amount exceeds your wallet balance.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final amount = amountController.text;
                  CharityCubit.get(context).donatForFund(context: context, amount: amount);
                }
              },
              child: Text('Donate'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Login Required',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          content: Text(
            'You need to be logged in to make a donation. Please log in to continue.',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
               navigateAndFinish(context, LoginScreen());
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final token = CacheHelper.getData(key: 'token');
    final bool isLoggedIn = token != null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80, // Adjust height as needed
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Theme.of(context).colorScheme.onBackground,
                selectedFontSize: 16,
                unselectedFontSize: 13,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.campaign),
                    label: 'Campaigns',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.request_page),
                    label: 'Requests',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'Previous Donations',
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isLoggedIn) {
            _showDonationDialog(context);
          } else {
            _showLoginPrompt(context);
          }
        },
        child: Icon(Icons.attach_money),
        backgroundColor: isLoggedIn
            ? Theme.of(context).colorScheme.primary
            : Colors.grey, // Grey color if not logged in
      ),
    );
  }
}
