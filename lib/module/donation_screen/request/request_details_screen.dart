import 'dart:math';
import 'package:charity/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/cubit/charity_cubit.dart';
import '../../../shared/styles/theme.dart';
import '../../auth_screens/login_screen/login_screen.dart';
import '../../../shared/network/local/cache_helper.dart';

class RequestDetailsPage extends StatefulWidget {
  final String title;
  final String requestId;

  RequestDetailsPage({required this.title,required this.requestId});

  @override
  State<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharityCubit, CharityState>(
      listener: (context, state) {
        // Optionally handle specific states here, e.g., errors
      },
      builder: (context, state) {
        var cubit = CharityCubit.get(context);
        final token = CacheHelper.getData(key: 'token');

        if (cubit.loadingRequestDetails) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              title: Text('Request Details', style: TextStyle(color: kPrimaryColor)),
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

        if (cubit.requestDetailsModel.isEmpty) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              title: Text('Request Details', style: TextStyle(color: kPrimaryColor)),
              backgroundColor: kPrimaryColor,
              elevation: 0,
            ),
            body: Center(
              child: Text(
                'No request details available.',
                style: TextStyle(fontSize: 18, color: kTextColor),
              ),
            ),
          );
        }

        final request = cubit.requestDetailsModel.first;

        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            title: Text('Request Details', style: TextStyle(color: kSecondaryColor)),
            backgroundColor: kPrimaryColor,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/request.jpg',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  request.description2 ?? "No description available.",
                  style: TextStyle(
                    fontSize: 18,
                    color: kTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.priority_high,
                      color: _getPriorityColor(request.priority ?? 3),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getPriorityLabel(request.priority ?? 3),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getPriorityColor(request.priority ?? 3),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (token == null) {
                        _showLoginPrompt(context);
                      } else {
                        _showDonationDialog(context, widget.requestId);
                      }
                    },
                    child: Text('Donate to this Request'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: kPrimaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 5,
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

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'High Priority';
      case 2:
        return 'Medium Priority';
      case 3:
        return 'Low Priority';
      default:
        return 'Unknown Priority';
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red; // High priority color
      case 2:
        return Colors.orange; // Medium priority color
      case 3:
        return Colors.green; // Low priority color
      default:
        return Colors.grey; // Default color
    }
  }

  void _showDonationDialog(BuildContext context, String requestId) {
    final TextEditingController amountController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Donate to Request',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5, // Limit height to 50% of screen height
            ),
            child: SingleChildScrollView(
              child: Form(
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
                  CharityCubit.get(context).donatToRequest(
                    context: context,
                    id: requestId,
                    amount: amount,
                  );
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
}
