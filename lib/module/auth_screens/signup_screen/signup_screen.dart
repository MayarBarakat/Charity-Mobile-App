import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:lottie/lottie.dart';
import '../../../shared/components/components.dart';
import '../../../shared/cubit/charity_cubit.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nationalNumberController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final birthdateController = TextEditingController();
  final addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharityCubit, CharityState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = CharityCubit.get(context);

        return BlurryModalProgressHUD(
          inAsyncCall: cubit.loadingSignup,
          blurEffectIntensity: 4,
          progressIndicator: const SpinKitFadingCircle(
            color: Color(0xFF577D86),
            size: 90.0,
          ),
          dismissible: false,
          opacity: 0.4,
          color: Colors.black.withOpacity(.1),
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Lottie.asset(
                          'assets/lottie/auth.json',
                          height: 300,
                          frameRate: FrameRate(60),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          "Create your account.",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 25),
                        MyTextField(
                          controller: nationalNumberController,
                          hintText: "National Number",
                          obscureText: false,
                          inputType: TextInputType.number,
                          prefixIcon: Icons.person,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'National number is required'),
                            MinLengthValidator(10, errorText: 'Minimum 10 digits required'),
                          ]).call,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: nameController,
                          hintText: "Name",
                          obscureText: false,
                          inputType: TextInputType.text,
                          prefixIcon: Icons.person_outline,
                          validator: RequiredValidator(errorText: 'Name is required').call,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: emailController,
                          hintText: "Email",
                          obscureText: false,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Email is required'),
                            EmailValidator(errorText: 'Enter a valid email address'),
                          ]).call,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: passwordController,
                          hintText: "Password",
                          obscureText: true,
                          inputType: TextInputType.text,
                          prefixIcon: Icons.lock,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Password is required'),
                            MinLengthValidator(6, errorText: 'Minimum 6 characters required'),
                          ]).call,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: phoneNumberController,
                          hintText: "Phone Number",
                          obscureText: false,
                          inputType: TextInputType.phone,
                          prefixIcon: Icons.phone,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Phone number is required'),
                            MinLengthValidator(10, errorText: 'Minimum 10 digits required'),
                          ]).call,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: birthdateController,
                          hintText: "Birthdate",
                          obscureText: false,
                          inputType: TextInputType.datetime,
                          prefixIcon: Icons.calendar_today,
                          validator: RequiredValidator(errorText: 'Birthdate is required').call,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                birthdateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: addressController,
                          hintText: "Address",
                          obscureText: false,
                          inputType: TextInputType.text,
                          prefixIcon: Icons.home,
                          validator: RequiredValidator(errorText: 'Address is required').call,
                        ),
                        const SizedBox(height: 35),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: MyButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                cubit.signup(
                                  context: context,
                                  nationalNumber: nationalNumberController.text,
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phoneNumber: phoneNumberController.text,
                                  birthDate: birthdateController.text,
                                  address: addressController.text,
                                );
                              }
                            },
                            text: "Signup",
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Powered By Charity Team",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              child: TextButton(
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
