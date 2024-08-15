import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charity/shared/cubit/charity_cubit.dart';

class PreviousRequestsScreen extends StatelessWidget {
  const PreviousRequestsScreen({super.key});

  String getStatusMessage(int status) {
    String response = '';
    if ((status % 2) == 1) {
      status -= 1;
      response+= 'Visit time set, ';
    }
    if (((status / 2) % 2) == 1) {
      status -= 2;
      response+= 'Visit completed, ';
    }
    if (((status / 4) % 2) == 1) {
      status -= 4;
      response+= 'Request presented for donation, ';
    }
    if (((status / 8) % 2) == 1) {
      status -= 8;
      response+= 'Request allocated, ';
    }
    if (((status / 16) % 2) == 1) {
      status -= 16;
      response+= 'Submitted via reception, ';
    }
    if (((status / 32) % 2) == 1) {
      status -= 32;
      response+= 'Request delivered, ';
    }
    if (((status / 64) % 2) == 1) {
      status -= 64;
      response+= 'Request rejected by management, ';
    }
    if (((status / 128) % 2) == 1) {
      status -= 128;
      response+= 'Request canceled by user, ';
    }if(response == ''){
      response+= 'Unknown status';
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharityCubit, CharityState>(
      listener: (context, state) {
       
      },
      builder: (context, state) {
        var cubit = CharityCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Previous Requests',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: cubit.loadingPreviousRequest
                ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
                : cubit.isRequestGet
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'An error occurred. Please try again.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      cubit.getPreviousModel(context: context);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
                : ListView.separated(
              itemCount: cubit.previousRequestModel.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                var request = cubit.previousRequestModel[index];
                return Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Indicator
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: _getStatusColor(request.status!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            getStatusMessage(request.status!),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Request Details
                        Text(
                          'Request Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          request.description1!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (getStatusMessage(request.status!) == 'Unknown status')
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                _showCancelConfirmationDialog(context, request.id!);
                              },
                              child: const Text(
                                'Cancel Request',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(int status) {
    // Define status colors here
    if ((status % 2) == 1) return Colors.blue;
    if (((status / 2) % 2) == 1) return Colors.green;
    if (((status / 4) % 2) == 1) return Colors.orange;
    if (((status / 8) % 2) == 1) return Colors.purple;
    if (((status / 16) % 2) == 1) return Colors.green;
    if (((status / 32) % 2) == 1) return Colors.cyan;
    if (((status / 64) % 2) == 1) return Colors.red;
    if (((status / 128) % 2) == 1) return Colors.black;
    return Colors.black38;
  }

  void _showCancelConfirmationDialog(BuildContext context, int requestId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Cancellation',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure you want to cancel this request?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                'Request Details:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Request ID: $requestId', // Customize with more request details as needed
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {

                await _performCancelRequest(context, requestId);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performCancelRequest(BuildContext context, int requestId) async {
    final cubit = CharityCubit.get(context);
    try {
      await cubit.requestCancel(
        context: context,
        idRequest: requestId,
      );
    } catch (error) {
      print('Error while deleting the request: $error');
    }
  }
}
