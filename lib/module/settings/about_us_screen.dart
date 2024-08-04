import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charity/shared/cubit/charity_cubit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<CharityCubit, CharityState>(
        builder: (context, state) {
          var cubit = CharityCubit.get(context);

          if (cubit.loadingAboutUs) {
            return Center(
              child: SpinKitFadingCircle(
                color: Theme.of(context).colorScheme.primary,
                size: 90.0,
              ),
            );
          }

          var aboutUs = cubit.aboutUsModel.first;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage('assets/images/aboutus.webp'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextSection(
                    context,
                    title: 'Who We Are',
                    content: aboutUs.text1!,
                  ),
                  _buildTextSection(
                    context,
                    title: 'Our Mission',
                    content: aboutUs.text2!,
                  ),
                  _buildTextSection(
                    context,
                    title: 'Our Vision',
                    content: aboutUs.text3!,
                  ),
                  _buildTextSection(
                    context,
                    title: 'Our Values',
                    content: aboutUs.text4!,
                  ),
                  _buildTextSection(
                    context,
                    title: 'Our Impact',
                    content: aboutUs.text5!,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showContactUsDialog(context, aboutUs.contactUs!);
                    },
                    child: Text('Contact Us'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextSection(BuildContext context, {required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _showContactUsDialog(BuildContext context, String contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Us', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          content: Text('You can reach us at: $contact'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }
}
