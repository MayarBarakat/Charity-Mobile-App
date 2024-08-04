import 'package:charity/layout/charity_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:lottie/lottie.dart';
import '../../../shared/components/components.dart';
import '../../../shared/cubit/charity_cubit.dart';
import '../signup_screen/signup_screen.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
          inAsyncCall: cubit.loadingLogin,
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
                        const SizedBox(height: 12),
                        Lottie.asset(
                          'assets/lottie/auth.json',
                          height: 300,
                          frameRate: FrameRate(60),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          "Welcome to Charity.",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 25),
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
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
                                );
                              },
                              child: const Text(
                                "Forget Password?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: MyButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                cubit.login(
                                  context: context,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: "Login",
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
                              "Not subscribed?",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              child: TextButton(
                                child: const Text(
                                  "Create Account",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                                  );
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
            // FloatingActionButton positioned at the bottom-left corner
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  cubit.refresh();
                  navigateAndFinish(context, const CharityLayout());
                },
                backgroundColor: Theme.of(context).colorScheme.secondary, // Use secondary color
                icon: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                label: const Text(
                  "As a Guest",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                tooltip: "Use app as a Guest", // Tooltip for additional information
              ),
            ),
          ),
        );
      },
    );
  }
}
