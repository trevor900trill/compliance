import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widget/custom_stepper.dart';

class EnforcementPage extends StatelessWidget {
  const EnforcementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      pageTitle: "Enforcement",
      steps: [
        CustomStep(title: 'Violation Details', content: _buildViolationStep()),
        CustomStep(
          title: 'Offender Information',
          content: _buildOffenderStep(),
        ),
        CustomStep(title: 'Review & Issue Notice', content: _buildReviewStep()),
      ],
      onComplete: () {
        // Handle completion
      },
    );
  }

  Widget _buildViolationStep() {
    return Column(
      children: [
        DropdownButtonFormField(
          items: const [
            DropdownMenuItem(
              value: 'Illegal Parking',
              child: Text('Illegal Parking'),
            ),
            DropdownMenuItem(
              value: 'Unlicensed Business',
              child: Text('Unlicensed Business'),
            ),
            DropdownMenuItem(
              value: 'Noise Pollution',
              child: Text('Noise Pollution'),
            ),
          ],
          onChanged: (value) {},
          decoration: const InputDecoration(labelText: 'Type of Violation'),
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Description of Violation',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildOffenderStep() {
    return Column(
      children: const [
        TextField(decoration: InputDecoration(labelText: 'Offender Name')),
        SizedBox(height: 16),
        TextField(decoration: InputDecoration(labelText: 'ID Number')),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review the notice details before issuing.',
          style: GoogleFonts.lato(fontSize: 16),
        ),
        const SizedBox(height: 24),
        _buildReviewRow('Violation:', 'Illegal Parking'),
        _buildReviewRow('Offender:', 'Jane Doe'),
        _buildReviewRow('ID Number:', '87654321'),
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
