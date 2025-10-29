import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widget/custom_stepper.dart';
import '../repository/validate_document_repository.dart';

class ValidateDocumentPage extends StatefulWidget {
  const ValidateDocumentPage({super.key});

  @override
  State<ValidateDocumentPage> createState() => _ValidateDocumentPageState();
}

class _ValidateDocumentPageState extends State<ValidateDocumentPage> {
  final _formKey = GlobalKey<FormState>();
  final _documentNumberController = TextEditingController();
  final ValidateDocumentRepository _repository = ValidateDocumentRepository();
  Map<String, dynamic>? _verificationResult;
  bool _isLoading = false;
  int _currentStep = 0;

  Future<void> _verifyDocument() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _verificationResult = null;
        _currentStep = 1; // Move to verification step
      });

      try {
        final result =
            await _repository.validateDocument(_documentNumberController.text);
        setState(() {
          _verificationResult = result;
        });
      } catch (e) {
        setState(() {
          _verificationResult = {
            'valid': false,
            'message': 'Error: ${e.toString()}',
            'data': {}
          };
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      _verifyDocument();
    } else if (_currentStep == 1 &&
        _verificationResult != null &&
        _verificationResult!['valid'] == true) {
      setState(() {
        _currentStep = 2; // Move to details step
      });
    } else {
      // Reset or handle completion
      setState(() {
        _currentStep = 0;
        _documentNumberController.clear();
        _verificationResult = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      pageTitle: 'Validate Document',
      currentStep: _currentStep,
      onStepContinue: _onStepContinue,
      steps: [
        CustomStep(
          title: 'Enter Document Number',
          content: _buildEnterDetailsStep(),
        ),
        CustomStep(
          title: 'Verification',
          content: _buildVerifyStep(),
        ),
        CustomStep(
          title: 'Details',
          content: _buildDetailsStep(),
        ),
      ],
      onComplete: () {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Validation Process Finished!')));
        setState(() {
          _currentStep = 0;
          _documentNumberController.clear();
          _verificationResult = null;
        });
      },
    );
  }

  Widget _buildEnterDetailsStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Document Information',
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _documentNumberController,
            decoration: const InputDecoration(
              labelText: 'Document Number',
              hintText: 'Enter document number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a Document Number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyStep() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Verifying Document...'),
          ],
        ),
      );
    }

    if (_verificationResult == null) {
      // This state should ideally not be seen if logic is correct
      return const Center(child: Text('Waiting to verify...'));
    }

    final bool isValid = _verificationResult!['valid'] ?? false;
    final String message =
        _verificationResult!['message'] ?? 'An unknown error occurred.';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isValid ? Icons.check_circle_outline : Icons.highlight_off,
            color: isValid ? Colors.green : Colors.red,
            size: 80,
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isValid ? Colors.green : Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    if (_verificationResult == null || _verificationResult!['valid'] != true) {
      return const Center(
        child: Text('No details to display.'),
      );
    }

    final data = _verificationResult!['data'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verified Document Details',
          style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildDetailRow('Document Number:', data['document_number'] ?? 'N/A'),
        _buildDetailRow('Document Type:', data['document_type'] ?? 'N/A'),
        _buildDetailRow('Status:', data['status'] ?? 'N/A'),
        _buildDetailRow('Date Verified:', data['date_verified'] ?? 'N/A'),
        _buildDetailRow('Verifier:', data['verifier'] ?? 'N/A'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.lato(),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
