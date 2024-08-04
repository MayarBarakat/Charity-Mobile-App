import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:lottie/lottie.dart';
import '../../../shared/components/components.dart';
import '../../../shared/cubit/charity_cubit.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _codeFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  int _currentStep = 0;

  void _nextStep() {
    setState(() {
      if (_currentStep < 2) {
        _currentStep++;
      }
    });
  }

  void _prevStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharityCubit, CharityState>(
      listener: (context, state) {
        if(state is CharitySendEmailInPasswordSuccessfullyState){
          _nextStep();
        }
      },
      builder: (context, state) {
        var cubit = CharityCubit.get(context);
        return BlurryModalProgressHUD(
          inAsyncCall: cubit.loadingSendEmailInResetPassword || cubit.loadingResetConfirmation,
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
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
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
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 900),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          child: _buildCurrentStep(),
                        ),
                        const SizedBox(height: 35),
                        if (_currentStep > 0)
                          ElevatedButton(
                            onPressed: _prevStep,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Theme.of(context).colorScheme.secondary, // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding
                              elevation: 5, // Shadow
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ), // Text style
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_back, color: Colors.white), // Icon
                                SizedBox(width: 8), // Spacing
                                Text(
                                  "Back",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )

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

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildEmailStep();
      case 1:
        return _buildCodeStep();
      case 2:
        return _buildPasswordStep();
      default:
        return _buildEmailStep();
    }
  }

  Widget _buildEmailStep() {
    return Form(
      key: _emailFormKey,
      child: Column(
        key: ValueKey<int>(_currentStep),
        children: [
          Text(
            "Enter your email address",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: _emailController,
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
          MyButton(
            onTap: () {
              if (_emailFormKey.currentState!.validate()) {
                // Send email to server
                CharityCubit.get(context).sendEmailInResetPassword(context: context, email: _emailController.text);
              }
            },
            text: "Send Code",
          ),
        ],
      ),
    );
  }

  Widget _buildCodeStep() {
    return Form(
      key: _codeFormKey,
      child: Column(
        key: ValueKey<int>(_currentStep),
        children: [
          Text(
            "Enter the code sent to your email",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: _codeController,
            hintText: "Enter 4-digit code",
            obscureText: false,
            inputType: TextInputType.number,
            prefixIcon: Icons.confirmation_number,
            validator: MultiValidator([
              RequiredValidator(errorText: 'Code is required'),
              LengthRangeValidator(
                min: 4,
                max: 4,
                errorText: 'Code must be 4 digits',
              ),
            ]).call,
            maxLength: 4,
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
          ),
          const SizedBox(height: 20),
          MyButton(
            onTap: () {
              if (_codeFormKey.currentState!.validate()) {
                // Verify code with server
                _nextStep();
              }
            },
            text: "Verify Code",
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStep() {
    return Form(
      key: _passwordFormKey,
      child: Column(
        key: ValueKey<int>(_currentStep),
        children: [
          Text(
            "Set a new password",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: _newPasswordController,
            hintText: "New Password",
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
            controller: _confirmPasswordController,
            hintText: "Confirm Password",
            obscureText: true,
            inputType: TextInputType.text,
            prefixIcon: Icons.lock,
            validator: (value) {
              if (value != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          MyButton(
            onTap: () {
              if (_passwordFormKey.currentState!.validate()) {
                // Send new password to server
                CharityCubit.get(context).resetConfirmation(context: context,
                    email: _emailController.text,
                    code: _codeController.text,
                    newPassword: _newPasswordController.text
                );
            // Optionally navigate to login screen
              }
            },
            text: "Reset Password",
          ),
        ],
      ),
    );
  }
}
