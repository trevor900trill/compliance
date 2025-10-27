import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widget/custom_stepper.dart';

class ValidateDocumentPage extends StatelessWidget {
  const ValidateDocumentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      steps: [
        CustomStep(title: 'Enter Details', content: _buildEnterDetailsStep()),
        CustomStep(title: 'Verify', content: _buildVerifyStep()),
        CustomStep(title: 'Details', content: _buildDetailsStep()),
      ],
      onComplete: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Validation Complete!')));
      },
    );
  }

  Widget _buildEnterDetailsStep() {
    return Form(
      child: Column(
        children: [
          Text(
            'Enter Document Information',
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Document ID',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a Document ID';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Owner ID Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an Owner ID Number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Verification Status',
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          const Icon(Icons.check_circle, color: Colors.green, size: 80),
          const SizedBox(height: 16),
          Text(
            'Document Verified Successfully!',
            style: GoogleFonts.lato(fontSize: 16, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Document Details',
          style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildDetailRow('Document ID:', '123456789'),
        _buildDetailRow('Owner Name:', 'John Doe'),
        _buildDetailRow('Issue Date:', '01/01/2023'),
        _buildDetailRow('Expiry Date:', '01/01/2024'),
        _buildDetailRow('Status:', 'Active'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
          Text(value, style: GoogleFonts.lato()),
        ],
      ),
    );
  }
}