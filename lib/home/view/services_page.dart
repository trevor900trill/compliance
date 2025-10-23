import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widget/custom_stepper.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      steps: [
        CustomStep(
          title: 'Select Service',
          content: _buildServiceSelectionStep(),
        ),
        CustomStep(
          title: 'Fill Details',
          content: _buildDetailsStep(),
        ),
        CustomStep(
          title: 'Payment',
          content: const PaymentStep(),
        ),
      ],
      onComplete: () {
        // Handle completion
      },
    );
  }

  Widget _buildServiceSelectionStep() {
    return Column(
      children: [
        DropdownButtonFormField(
          items: const [
            DropdownMenuItem(value: 'Business Permit', child: Text('Business Permit')),
            DropdownMenuItem(value: 'Parking Ticket', child: Text('Parking Ticket')),
            DropdownMenuItem(value: 'Land Rates', child: Text('Land Rates')),
          ],
          onChanged: (value) {},
          decoration: const InputDecoration(labelText: 'Select a Service'),
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    return Column(
      children: const [
        TextField(decoration: InputDecoration(labelText: 'Business Name')),
        SizedBox(height: 16),
        TextField(decoration: InputDecoration(labelText: 'Location')),
      ],
    );
  }
}

class PaymentStep extends StatefulWidget {
  const PaymentStep({super.key});

  @override
  _PaymentStepState createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> {
  String _paymentMethod = 'mpesa';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Choose a payment method.', style: GoogleFonts.lato(fontSize: 16)),
        const SizedBox(height: 24),
        RadioListTile<String>(
          title: const Text('M-Pesa'),
          value: 'mpesa',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Credit Card'),
          value: 'card',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value!;
            });
          },
        ),
      ],
    );
  }
}
