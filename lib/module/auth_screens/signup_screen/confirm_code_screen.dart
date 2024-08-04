import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:lottie/lottie.dart';
import '../../../shared/components/components.dart';
import '../../../shared/cubit/charity_cubit.dart';

class ConfirmCodeScreen extends StatefulWidget {
  final String email;

  const ConfirmCodeScreen({required this.email, super.key});

  @override
  _ConfirmCodeScreenState createState() => _ConfirmCodeScreenState();
}

class _ConfirmCodeScreenState extends State<ConfirmCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _codeFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharityCubit, CharityState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var cubit = CharityCubit.get(context);
        return BlurryModalProgressHUD(
          inAsyncCall: cubit.loadingConfirmCodeAfterSignup,
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
                        Text(
                          "Enter the code sent to your email",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Form(
                          key: _codeFormKey,
                          child: MyTextField(
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
                        ),
                        const SizedBox(height: 20),
                        MyButton(
                          onTap: () {
                            if (_codeFormKey.currentState!.validate()) {
                              // Confirm code with server
                              CharityCubit.get(context).confirmCode(
                                context: context,
                                email: widget.email,
                                code: _codeController.text,
                              );
                            }
                          },
                          text: "Confirm Code",
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
