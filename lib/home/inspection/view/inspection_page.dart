import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widget/custom_stepper.dart';

class InspectionPage extends StatelessWidget {
  const InspectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      steps: [
        CustomStep(
          title: 'Business Details',
          content: _buildBusinessDetailsStep(),
        ),
        CustomStep(
          title: 'Inspection Checklist',
          content: _buildChecklistStep(),
        ),
        CustomStep(title: 'Summary & Signature', content: _buildSummaryStep()),
      ],
      onComplete: () {
        // Handle completion
      },
    );
  }

  Widget _buildBusinessDetailsStep() {
    return Column(
      children: const [
        TextField(decoration: InputDecoration(labelText: 'Business Number')),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(labelText: 'Business Name'),
          enabled: false,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(labelText: 'Owner Name'),
          enabled: false,
        ),
      ],
    );
  }

  Widget _buildChecklistStep() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Valid Business Permit'),
          value: true,
          onChanged: (value) {},
        ),
        CheckboxListTile(
          title: const Text('Fire Safety Compliance'),
          value: false,
          onChanged: (value) {},
        ),
        CheckboxListTile(
          title: const Text('Health Certificate'),
          value: true,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildSummaryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary of inspection findings.',
          style: GoogleFonts.lato(fontSize: 16),
        ),
        const SizedBox(height: 24),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Inspector Notes',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        Text('Signature', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all()),
          child: const Center(child: Text('Sign Here')),
        ),
      ],
    );
  }
}
