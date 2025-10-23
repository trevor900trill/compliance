import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widget/custom_stepper.dart';
import 'package:myapp/theme.dart';

class ValidateDocumentPage extends StatelessWidget {
  const ValidateDocumentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      steps: [
        CustomStep(
          title: 'Scan',
          content: _buildScanStep(),
        ),
        CustomStep(
          title: 'Verify',
          content: _buildVerifyStep(),
        ),
        CustomStep(
          title: 'Details',
          content: _buildDetailsStep(),
        ),
      ],
      onComplete: () {
        // Handle completion
      },
    );
  }

  Widget _buildScanStep() {
    return Column(
      children: [
        Text(
          'Scan QR Code or Enter Document ID',
          style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        // Placeholder for QR Scanner
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.primaryColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(
              Icons.qr_code_scanner,
              size: 100,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('OR', style: GoogleFonts.lato(fontSize: 16)),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Document ID',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyStep() {
    return Column(
      children: [
        Text('Verification Status', style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        const Icon(Icons.check_circle, color: Colors.green, size: 80),
        const SizedBox(height: 16),
        Text('Document Verified Successfully!', style: GoogleFonts.lato(fontSize: 16, color: Colors.green)),
      ],
    );
  }

  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Document Details', style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold)),
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
        children: [
          Text(label, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(value, style: GoogleFonts.lato()),
        ],
      ),
    );
  }
}
