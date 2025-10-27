import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widget/custom_stepper.dart';

class CustomerManagementPage extends StatelessWidget {
  const CustomerManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      steps: [
        CustomStep(
          title: 'Personal Information',
          content: _buildPersonalInfoStep(),
        ),
        CustomStep(
          title: 'Contact Details',
          content: _buildContactDetailsStep(),
        ),
        CustomStep(
          title: 'Review & Save',
          content: _buildReviewStep(),
        ),
      ],
      onComplete: () {
        // Handle completion
      },
    );
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      children: const [
        TextField(decoration: InputDecoration(labelText: 'First Name')),
        SizedBox(height: 16),
        TextField(decoration: InputDecoration(labelText: 'Last Name')),
        SizedBox(height: 16),
        TextField(decoration: InputDecoration(labelText: 'National ID')),
      ],
    );
  }

  Widget _buildContactDetailsStep() {
    return Column(
      children: const [
        TextField(decoration: InputDecoration(labelText: 'Phone Number')),
        SizedBox(height: 16),
        TextField(decoration: InputDecoration(labelText: 'Email Address')),
        SizedBox(height: 16),
        TextField(decoration: InputDecoration(labelText: 'Physical Address')),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review your information before saving.', style: GoogleFonts.lato(fontSize: 16)),
        const SizedBox(height: 24),
        _buildReviewRow('First Name:', 'John'),
        _buildReviewRow('Last Name:', 'Doe'),
        _buildReviewRow('National ID:', '12345678'),
        _buildReviewRow('Phone Number:', '0712345678'),
        _buildReviewRow('Email Address:', 'john.doe@example.com'),
        _buildReviewRow('Physical Address:', '123, Nairobi'),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(label, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(value, style: GoogleFonts.lato()),
        ],
      ),
    );
  }
}
