import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme.dart';
import '../../../widget/custom_stepper.dart';
import '../../../widgets/customer_validation_step.dart';
import '../../../models/customer_validation_data.dart';

class LandRatesBillPage extends StatefulWidget {
  const LandRatesBillPage({super.key});

  @override
  State<LandRatesBillPage> createState() => _LandRatesBillPageState();
}

class _LandRatesBillPageState extends State<LandRatesBillPage> {
  int _currentStep = 0;
  bool _isLoading = false;
  final CustomerValidationData _customerData = CustomerValidationData();
  
  // Form data
  String? landParcelNumber;
  String? paymentMethod;
  
  // Mock property details
  final String propertyReferenceNo = 'NCG/LR/2024/001234';
  final double landRatesArrears = 12500.00;
  final double currentYearRates = 8500.00;

  final List<GlobalKey<FormState>> _formKeys = List.generate(3, (_) => GlobalKey<FormState>());

  void _onStepContinue() {
    if (_formKeys[_currentStep].currentState?.validate() ?? false) {
      if (_currentStep < 2) {
        setState(() => _currentStep++);
      } else {
        _completePayment();
      }
    }
  }

  void _onStepBack() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  void _completePayment() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful! Land rates bill settled.'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    });
  }

  double get totalAmount => landRatesArrears + currentYearRates;

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      pageTitle: 'Land Rates Bill',
      currentStep: _currentStep,
      isLoading: _isLoading,
      onStepContinue: _onStepContinue,
      onStepBack: _onStepBack,
      steps: [
        CustomStep(
          title: 'Customer Validation',
          content: CustomerValidationStep(
            data: _customerData,
            onDataChanged: (data) => _customerData,
          ),
        ),
        CustomStep(title: 'Property Details', content: _buildPropertyDetailsStep()),
        CustomStep(title: 'Confirm Details', content: _buildConfirmDetailsStep()),
        CustomStep(title: 'Payment', content: _buildPaymentStep()),
      ],
    );
  }

  Widget _buildPropertyDetailsStep() {
    return Form(
      key: _formKeys[1],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Property Details',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Please enter your Land Parcel Number to retrieve your rates information',
                style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your LRN can be found on your property title deed or previous rates bill',
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                initialValue: landParcelNumber,
                decoration: InputDecoration(
                  labelText: 'Land Parcel Number (LRN)',
                  hintText: 'e.g., NAIROBI/BLOCK123/456',
                  prefixIcon: Icon(Icons.location_on, color: AppTheme.primaryColor),
                  helperText: 'Enter your property Land Registration Number',
                ),
                textCapitalization: TextCapitalization.characters,
                onChanged: (value) => setState(() => landParcelNumber = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Land Parcel Number is required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Sample format display
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified, color: Colors.green.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Format: COUNTY/BLOCK/NUMBER',
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
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

  Widget _buildConfirmDetailsStep() {
    return Form(
      key: _formKeys[2],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm Property Details',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Please review your land rates information',
                style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              
              // Property Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_city, color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            landParcelNumber ?? 'N/A',
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Property Reference: $propertyReferenceNo',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Rates Breakdown
              _buildRatesCard(
                'Land Rates Arrears',
                landRatesArrears,
                Colors.orange.shade50,
                Colors.orange.shade700,
                Icons.warning_amber,
              ),
              
              const SizedBox(height: 12),
              
              _buildRatesCard(
                'Current Year Rates',
                currentYearRates,
                Colors.blue.shade50,
                Colors.blue.shade700,
                Icons.calendar_today,
              ),
              
              const SizedBox(height: 16),
              
              // Total Amount
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount Due',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.green.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'KES ${totalAmount.toStringAsFixed(2)}',
                          style: GoogleFonts.lato(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.payments, color: Colors.white, size: 28),
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

  Widget _buildRatesCard(String title, double amount, Color bgColor, Color textColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: textColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          Text(
            'KES ${amount.toStringAsFixed(2)}',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep() {
    return Form(
      key: _formKeys[2],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Make Payment',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your preferred payment method',
                style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              
              // Amount Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount:',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'KES ${totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Payment Options',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildPaymentMethod('M-Pesa', Icons.phone_android, Colors.green),
              const SizedBox(height: 12),
              _buildPaymentMethod('Bank Transfer', Icons.account_balance, Colors.blue),
              const SizedBox(height: 12),
              _buildPaymentMethod('Card Payment', Icons.credit_card, Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(String title, IconData icon, Color color) {
    final isSelected = paymentMethod == title;
    return GestureDetector(
      onTap: () => setState(() => paymentMethod = title),
      child: AnimatedContainer(
        duration: AppTheme.mediumAnimation,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppTheme.cardShadow : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : AppTheme.textColor,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color, size: 28),
          ],
        ),
      ),
    );
  }
}
