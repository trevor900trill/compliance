import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme.dart';
import '../../../widget/custom_stepper.dart';
import '../../../widgets/customer_validation_step.dart';
import '../model/ubp_form_data.dart';

class UnifiedBusinessPermitPage extends StatefulWidget {
  const UnifiedBusinessPermitPage({super.key});

  @override
  State<UnifiedBusinessPermitPage> createState() => _UnifiedBusinessPermitPageState();
}

class _UnifiedBusinessPermitPageState extends State<UnifiedBusinessPermitPage> {
  int _currentStep = 0;
  bool _isLoading = false;
  final UBPFormData _formData = UBPFormData();

  final List<GlobalKey<FormState>> _formKeys = List.generate(8, (_) => GlobalKey<FormState>());

  void _onStepContinue() {
    // Validate current step
    if (_formKeys[_currentStep].currentState?.validate() ?? false) {
      if (_currentStep < 7) {
        setState(() => _currentStep++);
      } else {
        _completeApplication();
      }
    }
  }

  void _onStepBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _completeApplication() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      pageTitle: 'Unified Business Permit',
      currentStep: _currentStep,
      isLoading: _isLoading,
      onStepContinue: _onStepContinue,
      onStepBack: _onStepBack,
      steps: [
        CustomStep(
          title: 'Customer Validation',
          content: CustomerValidationStep(
            data: _formData.customerData,
            onDataChanged: (data) => _formData.customerData = data,
          ),
        ),
        CustomStep(
          title: 'Business Category',
          content: _buildBusinessCategoryStep(),
        ),
        CustomStep(
          title: 'Business Details',
          content: _buildBusinessDetailsStep(),
        ),
        CustomStep(
          title: 'Business Activity',
          content: _buildBusinessActivityStep(),
        ),
        CustomStep(
          title: 'Business Contacts',
          content: _buildBusinessContactsStep(),
        ),
        CustomStep(
          title: 'Review & Submit',
          content: _buildReviewStep(),
        ),
        CustomStep(
          title: 'Payment Plan',
          content: _buildPaymentPlanStep(),
        ),
        CustomStep(
          title: 'Payment',
          content: _buildPaymentStep(),
        ),
      ],
    );
  }

  // Step 2: Business Category
  Widget _buildBusinessCategoryStep() {
    return Form(
      key: _formKeys[1],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Business Category Information',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                initialValue: _formData.brsNumber,
                decoration: const InputDecoration(
                  labelText: 'BRS Number',
                  hintText: 'Enter BRS Number',
                  prefixIcon: Icon(Icons.numbers),
                ),
                onChanged: (value) => _formData.brsNumber = value,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              Text(
                'Business Nature',
                style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              RadioListTile<String>(
                title: const Text('Registered/Formal'),
                value: 'Registered',
                groupValue: _formData.businessNature,
                onChanged: (value) => setState(() => _formData.businessNature = value),
              ),
              RadioListTile<String>(
                title: const Text('Unregistered/Informal'),
                value: 'Unregistered',
                groupValue: _formData.businessNature,
                onChanged: (value) => setState(() => _formData.businessNature = value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Step 3: Business Details
  Widget _buildBusinessDetailsStep() {
    return Form(
      key: _formKeys[2],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Business Location Details',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                initialValue: _formData.businessName,
                decoration: const InputDecoration(
                  labelText: 'Business Name',
                  prefixIcon: Icon(Icons.business),
                ),
                onChanged: (value) => _formData.businessName = value,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: _formData.streetName,
                decoration: const InputDecoration(
                  labelText: 'Street Name',
                  prefixIcon: Icon(Icons.location_on),
                ),
                onChanged: (value) => _formData.streetName = value,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _formData.plotNumber,
                      decoration: const InputDecoration(
                        labelText: 'Plot Number',
                        prefixIcon: Icon(Icons.pin),
                      ),
                      onChanged: (value) => _formData.plotNumber = value,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: _formData.floorNumber,
                      decoration: const InputDecoration(
                        labelText: 'Floor Number',
                        prefixIcon: Icon(Icons.layers),
                      ),
                      onChanged: (value) => _formData.floorNumber = value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: _formData.buildingName,
                decoration: const InputDecoration(
                  labelText: 'Building Name',
                  prefixIcon: Icon(Icons.apartment),
                ),
                onChanged: (value) => _formData.buildingName = value,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: _formData.roomStallNumber,
                decoration: const InputDecoration(
                  labelText: 'Room/Stall Number',
                  prefixIcon: Icon(Icons.door_front_door),
                ),
                onChanged: (value) => _formData.roomStallNumber = value,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Step 4: Business Activity
  Widget _buildBusinessActivityStep() {
    final industries = ['Retail', 'Manufacturing', 'Services', 'Technology', 'Food & Beverage'];
    final categories = ['Small Scale', 'Medium Scale', 'Large Scale'];

    return Form(
      key: _formKeys[3],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Business Activity Information',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              DropdownButtonFormField<String>(
                value: _formData.businessIndustry,
                decoration: const InputDecoration(
                  labelText: 'Business Industry',
                  prefixIcon: Icon(Icons.category),
                ),
                items: industries.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
                onChanged: (value) => setState(() => _formData.businessIndustry = value),
                validator: (value) => value == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _formData.businessCategory,
                decoration: const InputDecoration(
                  labelText: 'Business Category',
                  prefixIcon: Icon(Icons.auto_awesome_mosaic),
                ),
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (value) => setState(() => _formData.businessCategory = value),
                validator: (value) => value == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: _formData.businessSubCategory,
                decoration: const InputDecoration(
                  labelText: 'Business Sub-category',
                  prefixIcon: Icon(Icons.menu),
                ),
                onChanged: (value) => _formData.businessSubCategory = value,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: _formData.businessActivity,
                decoration: const InputDecoration(
                  labelText: 'Business Activity',
                  hintText: 'Describe main business activity',
                  prefixIcon: Icon(Icons.work_outline),
                ),
                maxLines: 3,
                onChanged: (value) => _formData.businessActivity = value,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Step 5: Business Contacts
  Widget _buildBusinessContactsStep() {
    return Form(
      key: _formKeys[4],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Business Contact Information',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                initialValue: _formData.email,
                decoration: const InputDecoration(
                  labelText: 'Business Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _formData.email = value,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  if (!value!.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: _formData.ownerMobileNumber,
                decoration: const InputDecoration(
                  labelText: 'Owner Mobile Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) => _formData.ownerMobileNumber = value,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _formData.poBox,
                      decoration: const InputDecoration(
                        labelText: 'P.O. Box',
                        prefixIcon: Icon(Icons.markunread_mailbox),
                      ),
                      onChanged: (value) => _formData.poBox = value,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: _formData.postalCode,
                      decoration: const InputDecoration(
                        labelText: 'Postal Code',
                        prefixIcon: Icon(Icons.local_post_office),
                      ),
                      onChanged: (value) => _formData.postalCode = value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              Text(
                'Contact Person Details',
                style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: _formData.contactPersonName,
                decoration: const InputDecoration(
                  labelText: 'Contact Person Name',
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (value) => _formData.contactPersonName = value,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: _formData.contactPersonPhone,
                decoration: const InputDecoration(
                  labelText: 'Contact Person Phone',
                  prefixIcon: Icon(Icons.phone_android),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) => _formData.contactPersonPhone = value,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: _formData.contactPersonEmail,
                decoration: const InputDecoration(
                  labelText: 'Contact Person Email',
                  prefixIcon: Icon(Icons.alternate_email),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _formData.contactPersonEmail = value,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Step 6: Review
  Widget _buildReviewStep() {
    return Form(
      key: _formKeys[5],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review Your Application',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              _buildReviewSection('Business Information', [
                ('Business Name', _formData.businessName),
                ('Industry', _formData.businessIndustry),
                ('Category', _formData.businessCategory),
              ]),
              
              _buildReviewSection('Location', [
                ('Street', _formData.streetName),
                ('Building', _formData.buildingName),
                ('Floor', _formData.floorNumber),
              ]),
              
              _buildReviewSection('Contact Details', [
                ('Email', _formData.email),
                ('Mobile', _formData.ownerMobileNumber),
                ('P.O. Box', _formData.poBox),
              ]),
              
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please review all information before proceeding to payment',
                        style: GoogleFonts.lato(color: Colors.green.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewSection(String title, List<(String, String?)> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 24),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.$1,
                        style: GoogleFonts.lato(color: Colors.grey[600]),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        item.$2 ?? 'Not provided',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // Step 7: Payment Plan
  Widget _buildPaymentPlanStep() {
    return Form(
      key: _formKeys[6],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Payment Plan',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              _buildPaymentOption(
                'Full Payment',
                'Pay the entire amount now',
                'KES 15,000',
                Icons.payments,
              ),
              const SizedBox(height: 16),
              
              _buildPaymentOption(
                'Installment',
                'Pay in 3 monthly installments',
                'KES 5,500/month',
                Icons.calendar_month,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, String subtitle, String amount, IconData icon) {
    final isSelected = _formData.paymentPlan == title;

    return GestureDetector(
      onTap: () => setState(() => _formData.paymentPlan = title),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppTheme.cardShadow : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.primaryGradient : null,
                color: isSelected ? null : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.lato(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 8: Payment
  Widget _buildPaymentStep() {
    return Form(
      key: _formKeys[7],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Method',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              _buildPaymentMethod('M-Pesa', Icons.phone_android, Colors.green),
              const SizedBox(height: 12),
              _buildPaymentMethod('Bank Transfer', Icons.account_balance, Colors.blue),
              const SizedBox(height: 12),
              _buildPaymentMethod('Card Payment', Icons.credit_card, Colors.orange),
              
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payment Plan:', style: GoogleFonts.lato()),
                        Text(
                          _formData.paymentPlan ?? 'Not selected',
                          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Amount:', style: GoogleFonts.lato(fontSize: 16)),
                        Text(
                          'KES 15,000',
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(String title, IconData icon, Color color) {
    final isSelected = _formData.paymentMethod == title;

    return GestureDetector(
      onTap: () => setState(() => _formData.paymentMethod = title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : AppTheme.textColor,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }
}
