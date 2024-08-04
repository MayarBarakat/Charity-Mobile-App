import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:charity/shared/cubit/charity_cubit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddRequestScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController workController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  AddRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharityCubit, CharityState>(
      listener: (context, state) {
        if (state is CharityAddRequestSuccessfullyState) {
          Navigator.pop(context); // Go back to the previous screen
        }
      },
      builder: (context, state) {
        var cubit = CharityCubit.get(context);
        return BlurryModalProgressHUD(
          inAsyncCall: cubit.loadingAddRequest,
          blurEffectIntensity: 4,
          progressIndicator: const SpinKitFadingCircle(
            color: Color(0xFF577D86),
            size: 90.0,
          ),
          dismissible: false,
          opacity: 0.4,
          color: Colors.black.withOpacity(.1),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Add Request',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'Fill out the form below to submit a new request.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height:40),
                      buildTextField(
                        context,
                        'Title',
                        'Enter the request title',
                        titleController,
                      ),
                      const SizedBox(height: 40),
                      buildTextField(
                        context,
                        'Work',
                        'Enter the work to be done',
                        workController,
                      ),
                      const SizedBox(height: 40),
                      buildTextField(
                        context,
                        'Reason',
                        'Enter the reason for the request',
                        reasonController,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            cubit.addRequest(
                              context: context,
                              title: titleController.text,
                              work: workController.text,
                              reason: reasonController.text,
                            );
                          }
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  TextFormField buildTextField(
      BuildContext context,
      String label,
      String hint,
      TextEditingController controller, {
        int maxLines = 1,
      }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
