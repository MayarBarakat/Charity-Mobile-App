import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/previous_donation_campaigns_model/previous_donation_campaigns_model.dart';
import '../../../models/previous_donation_requests_model/previous_donation_request_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/cubit/charity_cubit.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../../shared/styles/theme.dart';
import '../../auth_screens/login_screen/login_screen.dart';

class PreviousDonationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharityCubit, CharityState>(
      listener: (context, state) {
        // Optionally handle specific states here, e.g., errors
      },
      builder: (context, state) {
        var cubit = CharityCubit.get(context);
        final token = CacheHelper.getData(key: 'token');
        if (token == null) {
          // If no token, show login prompt
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Previous',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'You need to log in to access this page.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'This page allows you to manage your previous Donation Campaigns and requests and view past submissions. Please log in to proceed.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text('Go to Login'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: kBackgroundColor,
          body: cubit.loadingPreviousDonationCampaigns || cubit.loadingPreviousRequestsCampaigns
              ? Center(
            child: CircularProgressIndicator(color: kSecondaryColor),
          )
              : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Previous Campaigns List
                  Text(
                    'Previous Campaigns',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kPrimaryColor),
                  ),
                  const SizedBox(height: 10),
                  cubit.previousDonationCampaignsModel==null
                      ? Center(
                    child: Text(
                      'No previous campaigns available.',
                      style: TextStyle(fontSize: 16, color: kTextColor),
                    ),
                  )
                      : Container(
                    height: 220, // Adjust the height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cubit.previousDonationCampaignsModel.length,
                      itemBuilder: (context, index) {
                        final campaign = cubit.previousDonationCampaignsModel[index];
                        return CampaignCard(campaign: campaign);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Previous Requests List
                  Text(
                    'Previous Requests',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kPrimaryColor),
                  ),
                  const SizedBox(height: 10),
                  cubit.previousDonationRequestsModel.isEmpty
                      ? Center(
                    child: Text(
                      'No previous requests available.',
                      style: TextStyle(fontSize: 16, color: kTextColor),
                    ),
                  )
                      : Container(
                    height: 220, // Adjust the height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cubit.previousDonationRequestsModel.length,
                      itemBuilder: (context, index) {
                        final request = cubit.previousDonationRequestsModel[index];
                        return RequestCard(request: request);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        );
      },
    );
  }


}

class CampaignCard extends StatelessWidget {
  final PreviousDonationCampaignsModel campaign;

  CampaignCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Adjust the width as needed
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/campaign.jpg', width: double.infinity, height: 90, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(campaign.title!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor)),
            const SizedBox(height: 4),
            Text(getStatusMessage(campaign.status!), style: TextStyle(fontSize: 16, color: getStatusColor(campaign.status!))),
          ],
        ),
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  final PreviousDonationRequestsModel request;

  RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Adjust the width as needed
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/request.jpg', width: double.infinity, height: 90, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(request.title!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor)),
            const SizedBox(height: 4),
            Text(getStatusMessage(request.status!), style: TextStyle(fontSize: 16, color: getStatusColor(request.status!))),
          ],
        ),
      ),
    );
  }
}
