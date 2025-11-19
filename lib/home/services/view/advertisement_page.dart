import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme.dart';
import '../../../widget/custom_stepper.dart';
import '../../../widgets/customer_validation_step.dart';
import '../../../models/customer_validation_data.dart';

class AdvertisementPage extends StatefulWidget {
  const AdvertisementPage({super.key});

  @override
  State<AdvertisementPage> createState() => _AdvertisementPageState();
}

class _AdvertisementPageState extends State<AdvertisementPage> {
  int _currentStep = 0;
  bool _isLoading = false;
  final CustomerValidationData _customerData = CustomerValidationData();
  
  // Advertisement Details
  String? advertisementType;
  String? advertisementContent;
  String? advertisementSize;
  int numberOfAdverts = 1;
  
  // Location Details
  String? subCounty;
  String? ward;
  String? roadStreet;
  String? sideOfRoad;
  String? streetPoleNumber;
  String? exactLocationDescription;
  String? latitude;
  String? longitude;
  
  // Payment
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
      
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'Application Submitted!',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Application No: ADV-2024-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your advertisement permit application has been submitted successfully. You will receive a notification once it\'s approved.',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      );
    });
  }

  double get totalCost => numberOfAdverts * 3500.0;

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      pageTitle: 'Advertisement Permit',
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
        CustomStep(title: 'Advertisement Details', content: _buildAdvertisementDetailsStep()),
        CustomStep(title: 'Location', content: _buildLocationStep()),
        CustomStep(title: 'Review', content: _buildReviewStep()),
        CustomStep(title: 'Payment', content: _buildPaymentStep()),
      ],
    );
  }

  Widget _buildAdvertisementDetailsStep() {
    final adTypes = ['Billboard', 'Banner', 'Poster', 'Digital Display', 'Wall Branding'];
    final adSizes = ['Small (2x1m)', 'Medium (4x2m)', 'Large (6x3m)', 'Extra Large (10x5m)'];

    return Form(
      key: _formKeys[1],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Advertisement Information',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              DropdownButtonFormField<String>(
                value: advertisementType,
                decoration: InputDecoration(
                  labelText: 'Type of Advertisement',
                  prefixIcon: Icon(Icons.category, color: AppTheme.primaryColor),
                ),
                items: adTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (value) => setState(() => advertisementType = value),
                validator: (value) => value == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: advertisementContent,
                decoration: InputDecoration(
                  labelText: 'Content of Advertisement',
                  hintText: 'Describe what will be advertised',
                  prefixIcon: Icon(Icons.description, color: AppTheme.primaryColor),
                ),
                maxLines: 3,
                onChanged: (value) => advertisementContent = value,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: advertisementSize,
                decoration: InputDecoration(
                  labelText: 'Size of Advertisement',
                  prefixIcon: Icon(Icons.aspect_ratio, color: AppTheme.primaryColor),
                ),
                items: adSizes.map((size) => DropdownMenuItem(value: size, child: Text(size))).toList(),
                onChanged: (value) => setState(() => advertisementSize = value),
                validator: (value) => value == null ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              
              Text(
                'Number of Adverts',
                style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: numberOfAdverts > 1 ? () => setState(() => numberOfAdverts--) : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: AppTheme.primaryColor,
                    ),
                    Expanded(
                      child: Text(
                        numberOfAdverts.toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => numberOfAdverts++),
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              Text(
                'Cost: KES ${totalCost.toStringAsFixed(2)} (KES 3,500 per advert)',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationStep() {
    final subCounties = ['Westlands', 'Starehe', 'Embakasi', 'Kasarani', 'Dagoretti'];
    final wards = ['Parklands', 'Highridge', 'Nairobi Central', 'Kilimani'];

    return Form(
      key: _formKeys[2],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Advertisement Location',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              DropdownButtonFormField<String>(
                value: subCounty,
                decoration: InputDecoration(
                  labelText: 'Sub-County',
                  prefixIcon: Icon(Icons.location_city, color: AppTheme.primaryColor),
                ),
                items: subCounties.map((sc) => DropdownMenuItem(value: sc, child: Text(sc))).toList(),
                onChanged: (value) => setState(() => subCounty = value),
                validator: (value) => value == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: ward,
                decoration: InputDecoration(
                  labelText: 'Ward',
                  prefixIcon: Icon(Icons.map, color: AppTheme.primaryColor),
                ),
                items: wards.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                onChanged: (value) => setState(() => ward = value),
                validator: (value) => value == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: roadStreet,
                decoration: InputDecoration(
                  labelText: 'Road/Street',
                  prefixIcon: Icon(Icons.route, color: AppTheme.primaryColor),
                ),
                onChanged: (value) => roadStreet = value,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: sideOfRoad,
                      decoration: const InputDecoration(
                        labelText: 'Side of Road',
                        prefixIcon: Icon(Icons.compare_arrows),
                      ),
                      items: ['Left', 'Right', 'Center'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (value) => setState(() => sideOfRoad = value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: streetPoleNumber,
                      decoration: const InputDecoration(
                        labelText: 'Pole Number',
                        prefixIcon: Icon(Icons.location_searching),
                      ),
                      onChanged: (value) => streetPoleNumber = value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: exactLocationDescription,
                decoration: InputDecoration(
                  labelText: 'Exact Location Description',
                  hintText: 'Near landmark, building, etc.',
                  prefixIcon: Icon(Icons.place, color: AppTheme.primaryColor),
                ),
                maxLines: 2,
                onChanged: (value) => exactLocationDescription = value,
              ),
              const SizedBox(height: 24),
              
              Text(
                'Geolocation (Optional)',
                style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: latitude,
                      decoration: const InputDecoration(
                        labelText: 'Latitude',
                        hintText: '-1.2864',
                        prefixIcon: Icon(Icons.my_location),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => latitude = value,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: longitude,
                      decoration: const InputDecoration(
                        labelText: 'Longitude',
                        hintText: '36.8172',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => longitude = value,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    latitude = '-1.2864';
                    longitude = '36.8172';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Location captured from GPS')),
                  );
                },
                icon: const Icon(Icons.gps_fixed),
                label: const Text('Use Current Location'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewStep() {
    return Form(
      key: _formKeys[3],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review Application',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              _buildReviewSection('Advertisement Details', [
                ('Type', advertisementType),
                ('Content', advertisementContent),
                ('Size', advertisementSize),
                ('Number of Adverts', numberOfAdverts.toString()),
              ]),
              
              _buildReviewSection('Location', [
                ('Sub-County', subCounty),
                ('Ward', ward),
                ('Road/Street', roadStreet),
                ('Side of Road', sideOfRoad),
                ('Exact Location', exactLocationDescription),
              ]),
              
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Cost:',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'KES ${totalCost.toStringAsFixed(2)}',
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildPaymentStep() {
    return Form(
      key: _formKeys[4],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
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
                      'Amount to Pay:',
                      style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      'KES ${totalCost.toStringAsFixed(2)}',
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
