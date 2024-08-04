import 'package:charity/shared/cubit/charity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../shared/styles/theme.dart';

class CampaignDetailsScreen extends StatelessWidget {
  final String title;
  const CampaignDetailsScreen({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharityCubit, CharityState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    var cubit = CharityCubit.get(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body:cubit.loadingCampDetails?const Center(child: CircularProgressIndicator(
        color: kSecondaryColor,
        backgroundColor: kPrimaryColor,
      ),):
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Campaign Image as Lottie Animation
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Lottie.asset(
                'assets/lottie/campaign.json',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              cubit.campaignDetailsModel.first.description ?? 'No description available.',
              style: const TextStyle(
                fontSize: 16,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 24),

            // Budget and Target Group
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard('Budget', '\$${cubit.campaignDetailsModel.first.budget?.toStringAsFixed(2) ?? '0.00'}'),
                _buildInfoCard('Target Group', cubit.campaignDetailsModel.first.targetGroup ?? 'N/A'),
              ],
            ),
            const SizedBox(height: 24),

            // Reason
            const Text(
              'Reason for Campaign:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              cubit.campaignDetailsModel.first.reason ?? 'No reason provided.',
              style: const TextStyle(
                fontSize: 16,
                color: kTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  },
);
  }

  Widget _buildInfoCard(String title, String value) {
    return Expanded(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: kTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
