import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:charity/shared/components/components.dart';
import 'package:flutter/material.dart';

class ComplaintScreen extends StatefulWidget {
  @override
  _ComplaintScreenState createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _complaintController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _complaintController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _complaintController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle submission logic here
      showAwesomeSnackbar(context: context, message: 'The Complaint sent successfully',
          contentType: ContentType.success);
      _nameController.clear();
      _emailController.clear();
      _complaintController.clear();
      Navigator.pop(context);
      // Clear the form fields after submission

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit a Complaint', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email.';
                  }
                  final emailRegExp = RegExp(
                      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Please enter a valid email.';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _complaintController,
                label: 'Complaint',
                icon: Icons.description,
                maxLines: 5,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your complaint.' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitComplaint,
                child: Text('Submit Complaint'),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            gapPadding: 10,
          ),
          labelText: label,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
          contentPadding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
        ),
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }
}
