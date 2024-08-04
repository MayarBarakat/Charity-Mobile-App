import 'package:charity/models/campaigns_model/campaigns_model.dart';
import 'package:charity/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../shared/cubit/charity_cubit.dart';
import '../../shared/styles/theme.dart';
import 'campaign_details_screen.dart';

class CampaignScreen extends StatelessWidget {
  const CampaignScreen({super.key});

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
          body: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Discover and support various campaigns to make a difference in the world.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: cubit.loadingCampaign
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: kSecondaryColor,
                      backgroundColor: kPrimaryColor,
                    ),
                  )
                      : ListView.separated(
                    itemCount: cubit.campaignsModel.length,
                    separatorBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                color: kPrimaryColor,
                                thickness: 1.5,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Icon(
                              Icons.star,
                              color: kPrimaryColor,
                              size: 20,
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Divider(
                                color: kPrimaryColor,
                                thickness: 1.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemBuilder: (context, index) {
                      return CampaignCard(campaign: cubit.campaignsModel[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CampaignCard extends StatelessWidget {
  final CampaignsModel campaign;

  const CampaignCard({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(context, CampaignDetailsScreen(title: campaign.title!));
        CharityCubit.get(context).getCampDetails(id: campaign.id.toString());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Image or Lottie animation
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: kPrimaryColor,
                  width: 3,
                ),
                color: Colors.grey[200], // Fallback color for cases when Lottie fails to load
              ),
              child: ClipOval(
                child: Lottie.asset(
                  'assets/lottie/campaign.json',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.title!,
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A short description or tagline for the campaign goes here.',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: kSecondaryColor,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Limited Time',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 20),
                      Icon(
                        Icons.location_on,
                        color: kSecondaryColor,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Global',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


