import 'package:charity/module/donation_screen/campaign/campaign_details_from_donation_screen.dart';
import 'package:charity/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/cubit/charity_cubit.dart';

class CampaignsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharityCubit, CharityState>(
      listener: (context, state) {
        // Optionally handle specific states here
      },
      builder: (context, state) {
        var cubit = CharityCubit.get(context);

        if (cubit.loadingCampaign) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,

          body: cubit.campaignsModel.isEmpty
              ? Center(
            child: Text(
              'No campaigns available.',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          )
              : ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: cubit.campaignsModel.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemBuilder: (context, index) {
              final campaign = cubit.campaignsModel[index];
              return _buildCampaignCard(
                context,
                campaign.id!,
                campaign.title!,
                'assets/images/campaign.jpg',
                'description',
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCampaignCard(BuildContext context, int id, String title, String imagePath, String description) {
    return InkWell(
      onTap: () {
        CharityCubit.get(context).getCampDetails(id: id.toString());
        navigateTo(context, CampaignDetailsFromDonationPage(title: title,id: id.toString(),));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            SizedBox(height: 8.0), // Adds extra space at the bottom of the card
          ],
        ),
      ),
    );
  }


}
