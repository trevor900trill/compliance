import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme.dart';
import '../../../widget/custom_stepper.dart';
import '../../../widgets/customer_validation_step.dart';
import '../../../models/customer_validation_data.dart';

class FireDisasterManagementPage extends StatefulWidget {
  const FireDisasterManagementPage({super.key});

  @override
  State<FireDisasterManagementPage> createState() => _FireDisasterManagementPageState();
}

class _FireDisasterManagementPageState extends State<FireDisasterManagementPage> {
  int _currentStep = 0;
  bool _isLoading = false;
  final CustomerValidationData _customerData = CustomerValidationData();
  
  // Form data
  String? serviceCategory, serviceItem, applicationType;
  String? businessName, subsidiaryName, subCounty, ward, estate, street;
  String? buildingName, plotNumber, stallNumber, floor;
  String? contactName, contactEmail, contactMobile, contactAddress;
  String? physicalAddress, additionalInfo;
  String? paymentMethod;

  final List<GlobalKey<FormState>> _formKeys = List.generate(5, (_) => GlobalKey<FormState>());

  void _onStepContinue() {
    if (_formKeys[_currentStep].currentState?.validate() ?? false) {
      if (_currentStep < 4) {
        setState(() => _currentStep++);
      } else {
        _completeApplication();
      }
    }
  }

  void _onStepBack() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  void _completeApplication() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fire Certificate application submitted!'), backgroundColor: Colors.green),
      );
      context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      pageTitle: 'Fire & Disaster Certificate',
      currentStep: _currentStep,
      isLoading: _isLoading,
      onStepContinue: _onStepContinue,
      onStepBack: _onStepBack,
      steps: [
        CustomStep(
          title: 'Customer Validation',
          content: CustomerValidationStep(data: _customerData, onDataChanged: (data) => _customerData),
        ),
        CustomStep(title: 'Service Details', content: _buildServiceDetailsStep()),
        CustomStep(title: 'Physical Address', content: _buildPhysicalAddressStep()),
        CustomStep(title: 'Contact Details', content: _buildContactDetailsStep()),
        CustomStep(title: 'Payment', content: _buildPaymentStep()),
      ],
    );
  }

  Widget _buildServiceDetailsStep() {
    final categories = ['Fire Safety', 'Disaster Prevention', 'Emergency Response'];
    final items = ['New Certificate', 'Renewal', 'Inspection'];

    return Form(
      key: _formKeys[1],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Service Details', style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              
              DropdownButtonFormField<String>(
                value: serviceCategory,
                decoration: const InputDecoration(labelText: 'Service Category', prefixIcon: Icon(Icons.category)),
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => serviceCategory = v),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: serviceItem,
                decoration: const InputDecoration(labelText: 'Service Item', prefixIcon: Icon(Icons.list)),
                items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
                onChanged: (v) => setState(() => serviceItem = v),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              
              Text('Application Type', style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              RadioListTile<String>(
                title: const Text('New Application'),
                value: 'New',
                groupValue: applicationType,
                onChanged: (v) => setState(() => applicationType = v),
              ),
              RadioListTile<String>(
                title: const Text('Renewal'),
                value: 'Renewal',
                groupValue: applicationType,
                onChanged: (v) => setState(() => applicationType = v),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhysicalAddressStep() {
    return Form(
      key: _formKeys[2],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Physical Address', style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              
              TextFormField(
                initialValue: businessName,
                decoration: const InputDecoration(labelText: 'Business Name', prefixIcon: Icon(Icons.business)),
                onChanged: (v) => businessName = v,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: street,
                decoration: const InputDecoration(labelText: 'Street', prefixIcon: Icon(Icons.location_on)),
                onChanged: (v) => street = v,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: buildingName,
                      decoration: const InputDecoration(labelText: 'Building'),
                      onChanged: (v) => buildingName = v,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: floor,
                      decoration: const InputDecoration(labelText: 'Floor'),
                      onChanged: (v) => floor = v,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactDetailsStep() {
    return Form(
      key: _formKeys[3],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact Information', style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              
              TextFormField(
                initialValue: contactName,
                decoration: const InputDecoration(labelText: 'Contact Person Name', prefixIcon: Icon(Icons.person)),
                onChanged: (v) => contactName = v,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: contactEmail,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                onChanged: (v) => contactEmail = v,
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Required';
                  if (!v!.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: contactMobile,
                decoration: const InputDecoration(labelText: 'Mobile Number', prefixIcon: Icon(Icons.phone)),
                onChanged: (v) => contactMobile = v,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentStep() {
    return Form(
      key: _formKeys[4],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payment', style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Amount Due:', style: GoogleFonts.lato(color: Colors.white)),
                        Text('KES 5,000', style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              _buildPaymentMethod('M-Pesa', Icons.phone_android),
              const SizedBox(height: 12),
              _buildPaymentMethod('Bank Transfer', Icons.account_balance),
              const SizedBox(height: 12),
              _buildPaymentMethod('Card Payment', Icons.credit_card),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(String title, IconData icon) {
    final isSelected = paymentMethod == title;
    return GestureDetector(
      onTap: () => setState(() => paymentMethod = title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.grey),
            const SizedBox(width: 16),
            Text(title, style: GoogleFonts.lato(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }
}
