import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/home/services/bloc/services_bloc.dart';
import 'package:myapp/home/services/model/service_model.dart';
import 'package:myapp/widget/custom_stepper.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading || state is ServicesInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ServicesError) {
          return Center(child: Text('Error: ${state.error}'));
        } else if (state is ServicesLoaded) {
          return CustomStepper(
            pageTitle: 'Services',
            steps: [
              CustomStep(
                title: 'Select Service',
                content: _buildServiceSelectionStep(state.services),
              ),
              CustomStep(title: 'Fill Details', content: _buildDetailsStep()),
              CustomStep(title: 'Payment', content: const _PaymentStep()),
            ],
            onComplete: () {
              // Handle completion
            },
          );
        } else {
          return const Center(child: Text('Something went wrong!'));
        }
      },
    );
  }

  Widget _buildServiceSelectionStep(List<Service> services) {
    return Column(
      children: [
        DropdownButtonFormField<Service>(
          items: services.map((service) {
            return DropdownMenuItem<Service>(
              value: service,
              child: Text(service.name),
            );
          }).toList(),
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

class _PaymentStep extends StatefulWidget {
  const _PaymentStep();

  @override
  _PaymentStepState createState() => _PaymentStepState();
}

class _PaymentStepState extends State<_PaymentStep> {
  String _paymentMethod = 'mpesa';

  Widget _buildRadioOption(String title, String value) {
    return InkWell(
      onTap: () => setState(() => _paymentMethod = value),
      child: Row(
        children: [
          RadioMenuButton(
            value: value,
            groupValue: _paymentMethod,
            onChanged: (String? value) {
              setState(() {
                _paymentMethod = value!;
              });
            },
            child: Text(title),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose a payment method.', style: GoogleFonts.lato(fontSize: 16)),
        const SizedBox(height: 10),
        _buildRadioOption('M-Pesa', 'mpesa'),
        _buildRadioOption('Credit Card', 'card'),
      ],
    );
  }
}
