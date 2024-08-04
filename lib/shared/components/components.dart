import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:charity/shared/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType inputType;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final int? maxLength;
  final InputCounterWidgetBuilder? buildCounter;
  final VoidCallback? onTap;

  const MyTextField({super.key, 
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.inputType,
    required this.prefixIcon,
    this.validator,
    this.maxLength,
    this.buildCounter,
    this.onTap,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _isObscured,
        keyboardType: widget.inputType,
        validator: widget.validator,
        maxLength: widget.maxLength,
        buildCounter: widget.buildCounter,
        onTap: widget.onTap,
        readOnly: widget.onTap != null,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.prefixIcon, color: Theme.of(context).colorScheme.secondary),
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: _toggleObscureText,
          )
              : null,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}



class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.onTap, required this.text});

  final Function()? onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        // margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(12)
        ),
        child:  Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);
void navigateAndFinish(
    context,
    widget,
    ) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
          (route) {
        return false;
      },
    );

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}
void showAwesomeSnackbar({
  required BuildContext context,
  required String message,
  required ContentType contentType,
}) {
  final snackBar = SnackBar(
    content: AwesomeSnackbarContent(
      title: 'Attention!',
      message: message,
      contentType: contentType,
    ),
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    elevation: 0,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

String getStatusMessage(int status) {
  if ((status % 2) == 1) {
    status -= 1;
    return 'Visit time set';
  }
  if (((status / 2) % 2) == 1) {
    status -= 2;
    return 'Visit completed';
  }
  if (((status / 4) % 2) == 1) {
    status -= 4;
    return 'Request presented for donation';
  }
  if (((status / 8) % 2) == 1) {
    status -= 8;
    return 'Request allocated';
  }
  if (((status / 16) % 2) == 1) {
    status -= 16;
    return 'Submitted via reception';
  }
  if (((status / 32) % 2) == 1) {
    status -= 32;
    return 'Request delivered';
  }
  if (((status / 64) % 2) == 1) {
    status -= 64;
    return 'Request rejected by management';
  }
  if (((status / 128) % 2) == 1) {
    status -= 128;
    return 'Request canceled by user';
  }
  return 'Unknown status';
}

Color getStatusColor(int status) {
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

