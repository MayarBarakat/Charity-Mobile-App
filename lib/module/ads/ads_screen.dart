import 'package:charity/models/ads_model/ads_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../shared/cubit/charity_cubit.dart';
import '../../shared/styles/theme.dart';

class AdsScreen extends StatelessWidget {
  const AdsScreen({super.key});

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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Explore our advertisements to learn about the latest campaigns and opportunities.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(
                  child: cubit.loadingAds
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: kSecondaryColor,
                      backgroundColor: kPrimaryColor,
                    ),
                  )
                      : ListView.separated(
                    itemCount: cubit.ads.length,
                    separatorBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      return AdCard(ad: cubit.ads[index]);
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

class AdCard extends StatelessWidget {
  final AdsModel ad;

  const AdCard({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image or Lottie animation
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.grey[200], // Fallback color for cases when Lottie fails to load
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Lottie.asset(
                'assets/lottie/ads.json',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ad.title!,
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ad.description!,
                  style: const TextStyle(
                    color: kTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icons or additional information
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: kPrimaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Limited Time',
                          style: TextStyle(color: kPrimaryColor, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: kPrimaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Worldwide',
                          style: TextStyle(color: kPrimaryColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
