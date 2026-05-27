import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class RequestManageRidePage extends StatefulWidget {
  const RequestManageRidePage({super.key});

  @override
  State<RequestManageRidePage> createState() => _RequestManageRidePageState();
}

class _RequestManageRidePageState extends State<RequestManageRidePage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  String reason = 'work';
  String pickupBy = 'Ms. Tupi - 832-128-4415';

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Request Ride'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Divider(color: AppTheme.primaryGreen, thickness: 1.5),
              const SizedBox(height: 12),
              _lineField('Date of ride M/D/Y', _dateController),
              _lineField('Your Full Name', _nameController),
              _lineField('Phone Number', _phoneController),
              _lineField('Departure Address', _fromController),
              _lineField('Arrival Address', _toController),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: reason,
                decoration: const InputDecoration(labelText: 'Reason For Ride'),
                items: const [
                  DropdownMenuItem(value: 'work', child: Text('Work')),
                  DropdownMenuItem(
                    value: 'medical appt',
                    child: Text('Medical appt'),
                  ),
                  DropdownMenuItem(
                    value: 'dental appt',
                    child: Text('Dental appt'),
                  ),
                  DropdownMenuItem(value: 'school', child: Text('School')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) => setState(() => reason = value ?? reason),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: pickupBy,
                decoration: const InputDecoration(labelText: 'Pick Up By'),
                items: const [
                  DropdownMenuItem(
                    value: 'Ms. Tupi - 832-128-4415',
                    child: Text('Ms. Tupi - 832-128-4415'),
                  ),
                  DropdownMenuItem(
                    value: 'Mr. Brewer - 816-555-1010',
                    child: Text('Mr. Brewer - 816-555-1010'),
                  ),
                  DropdownMenuItem(
                    value: 'Ms. Lani - 816-555-6700',
                    child: Text('Ms. Lani - 816-555-6700'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => pickupBy = value ?? pickupBy),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Ride request submitted successfully.',
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Request Ride'),
                  ),
                  const SizedBox(width: 14),
                  IconButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                      _dateController.clear();
                      _nameController.clear();
                      _phoneController.clear();
                      _fromController.clear();
                      _toController.clear();
                    },
                    icon: const Icon(Icons.delete_outline, size: 32),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lineField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
