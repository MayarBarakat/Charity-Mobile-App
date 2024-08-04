import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/cubit/charity_cubit.dart';
import '../../../shared/styles/theme.dart';
import '../../auth_screens/login_screen/login_screen.dart';
import '../../../shared/network/local/cache_helper.dart';

class CampaignDetailsFromDonationPage extends StatelessWidget {
  final String title;
  final String id;

  CampaignDetailsFromDonationPage({required this.title, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharityCubit, CharityState>(
      listener: (context, state) {
        // Optionally handle specific states here
      },
      builder: (context, state) {
        var cubit = CharityCubit.get(context);
        final token = CacheHelper.getData(key: 'token');

        if (cubit.loadingCampDetails) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              title: Text('Campaign Details', style: TextStyle(color: kPrimaryColor)),
              backgroundColor: kPrimaryColor,
              elevation: 0,
            ),
            body: Center(
              child: CircularProgressIndicator(
                color: kSecondaryColor,
                backgroundColor: kPrimaryColor,
              ),
            ),
          );
        }

        final campaign = cubit.campaignDetailsModel.isNotEmpty
            ? cubit.campaignDetailsModel.first
            : null;

        if (campaign == null) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              title: Text('Campaign Details', style: TextStyle(color: kPrimaryColor)),
              backgroundColor: kPrimaryColor,
              elevation: 0,
            ),
            body: Center(
              child: Text(
                'No campaign details available.',
                style: TextStyle(fontSize: 16, color: kTextColor),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            title: Text('Campaign Details', style: TextStyle(color: kSecondaryColor)),
            backgroundColor: kPrimaryColor,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Campaign Image as Static Image
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/campaign.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Description and other details in Cards
                _buildDetailCard('Description', campaign.description ?? 'No description available.'),
                _buildDetailCard('Reason', campaign.reason ?? 'No reason provided.'),
                _buildDetailCard('Target Group', campaign.targetGroup ?? 'N/A'),
                _buildDetailCard('Budget', 'SYP ${campaign.budget?.toString() ?? '0'}'),
                const SizedBox(height: 20),

                // Donate Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (token == null) {
                        _showLoginPrompt(context);
                      } else {
                        _showDonationDialog(context, id);
                      }
                    },
                    child: Text('Donate to this Campaign'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: kPrimaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(String title, String content) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: kTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDonationDialog(BuildContext context, String campaignId) {
    final TextEditingController amountController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Donate to Campaign',
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
                  CharityCubit.get(context).donatToCampaign(
                    context: context,
                    id: campaignId,
                    amount: amount,
                  );
                  Navigator.of(context).pop(); // Close the dialog after donation
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
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
}
