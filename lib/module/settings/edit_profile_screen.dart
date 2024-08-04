import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../shared/cubit/charity_cubit.dart'; // Adjust the path as needed
import '../../../shared/styles/theme.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _birthDateController;

  @override
  void initState() {
    super.initState();
    final userModel = CharityCubit.get(context).userModel;
    _nameController = TextEditingController(text: userModel.first.name);
    _phoneController = TextEditingController(text: userModel.first.number);
    _addressController = TextEditingController(text: userModel.first.address);
    _birthDateController = TextEditingController(text: userModel.first.date);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = CharityCubit.get(context);
    return BlocConsumer<CharityCubit, CharityState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return BlurryModalProgressHUD(
      inAsyncCall: cubit.loadingEditProfile,
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
          title: Text('Edit Profile', style: TextStyle(color: Colors.white)),
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        backgroundColor: kBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.person,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your name.' : null,
                ),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number.' : null,
                ),
                _buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  icon: Icons.home,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your address.' : null,
                ),
                _buildTextField(
                  controller: _birthDateController,
                  label: 'Birth Date',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.datetime,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your birth date.' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      CharityCubit.get(context).editUser(
                        context: context,
                        name: _nameController.text,
                        fullNumber: _phoneController.text,
                        Date: _birthDateController.text,
                        addr: _addressController.text,
                        userId: '1',
                      );
                    }
                  },
                  child: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: kPrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          prefixIcon: Icon(icon),
        ),
        validator: validator,
      ),
    );
  }
}
