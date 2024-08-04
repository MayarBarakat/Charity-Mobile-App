import 'package:charity/shared/cubit/charity_cubit.dart';
import 'package:charity/shared/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CharityLayout extends StatefulWidget {
  const CharityLayout({super.key});

  @override
  State<CharityLayout> createState() => _CharityLayoutState();
}

class _CharityLayoutState extends State<CharityLayout> {
  @override
  Widget build(BuildContext context) {
    var cubit = CharityCubit.get(context);

    return BlocConsumer<CharityCubit, CharityState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CharityCubit.get(context);
        return SafeArea(
          child: Scaffold(
            backgroundColor: kBackgroundColor,
            body:!cubit.isHasInternet?Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                const Text('NO Internet Connection',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: kPrimaryColor),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => cubit.refresh(),
                  icon: const Icon(Icons.refresh_outlined,color: kSecondaryColor,),
                  label: const Text('Refresh',style: TextStyle(color: kSecondaryColor),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),): IndexedStack(
              index: cubit.currentIndex,
              children: cubit.bottomScreen,
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 8),
                child: GNav(
                  backgroundColor: kPrimaryColor,
                  color: Colors.white,
                  activeColor: kSecondaryColor,
                  tabBackgroundColor: Colors.white.withOpacity(0.1),
                  gap: 8,
                  padding: const EdgeInsets.all(16),
                  selectedIndex: cubit.currentIndex,
                  onTabChange: (index) {
                    cubit.changeBottom(index);
                  },
                  tabs: const [
                    GButton(
                      icon: Icons.campaign,
                      text: 'Campaign',
                    ),
                    GButton(
                      icon: Icons.ad_units,
                      text: 'Ads',
                    ),
                    GButton(
                      icon: Icons.request_page,
                      text: 'Requests',
                    ),

                    GButton(
                      icon: Icons.volunteer_activism,
                      text: 'Donation',
                    ),
                    GButton(
                      icon: Icons.settings,
                      text: 'Settings',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
