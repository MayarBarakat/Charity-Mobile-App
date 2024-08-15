import 'package:charity/module/donation_screen/request/request_details_screen.dart';
import 'package:charity/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/cubit/charity_cubit.dart';
import '../../../shared/styles/theme.dart';

class RequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharityCubit, CharityState>(
      listener: (context, state) {
        // Optionally handle specific states here
      },
      builder: (context, state) {
        var cubit = CharityCubit.get(context);

        if (cubit.loadingRequests) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                color: kSecondaryColor,
                backgroundColor: kPrimaryColor,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showDonationDialog(context),
              child: Icon(Icons.attach_money),
              backgroundColor: kPrimaryColor,
            ),
          );
        }

        return Scaffold(
          backgroundColor: kBackgroundColor,
          body: cubit.requestsModel.isEmpty
              ? Center(
            child: Text(
              'No requests available.',
              style: TextStyle(
                fontSize: 16,
                color: kTextColor,
              ),
            ),
          )
              : ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: cubit.requestsModel.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemBuilder: (context, index) {
              final request = cubit.requestsModel[index];
              return _buildRequestCard(context, request.title!,request.id.toString());
            },
          ),
        );
      },
    );
  }


  Widget _buildRequestCard(BuildContext context, String title,String id) {
    return InkWell(
      onTap: (){
        CharityCubit.get(context).getRequestDetailsModel(context: context, id: id);
        navigateTo(context, RequestDetailsPage(title: title,requestId: id,));
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.grey.withOpacity(0.5),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    'assets/images/request.jpg',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.darken,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 15,
              right: 15,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Request',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                  // Handle donation logic here
                  CharityCubit.get(context)
                      .donatForFund(context: context, amount: amount);
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
}
