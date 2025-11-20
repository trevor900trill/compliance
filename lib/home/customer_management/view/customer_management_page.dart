import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widget/custom_stepper.dart';
import '../../../widgets/customer_validation_step.dart';
import '../../../models/customer_validation_data.dart';
import '../repository/customer_management_repository.dart';

class CustomerManagementPage extends StatefulWidget {
  const CustomerManagementPage({super.key});

  @override
  State<CustomerManagementPage> createState() => _CustomerManagementPageState();
}

class _CustomerManagementPageState extends State<CustomerManagementPage> {
  final CustomerManagementRepository _repository =
      CustomerManagementRepository();

  int _currentStep = 0;
  String? _selectedAccountType;

  // Form Keys
  final _detailsFormKey = GlobalKey<FormState>();

  // Customer validation data
  final CustomerValidationData _customerData = CustomerValidationData();

  // Personal Information Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // Organization Information Controllers
  final _organizationNameController = TextEditingController();
  final _organizationTypeController = TextEditingController();
  final _kraPinController = TextEditingController();

  bool _isProcessing = false; // Combined loading state for all async operations

  // Form keys for validation
  final List<GlobalKey<FormState>> _formKeys = List.generate(3, (_) => GlobalKey<FormState>());

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _organizationNameController.dispose();
    _organizationTypeController.dispose();
    _kraPinController.dispose();
    super.dispose();
  }

  void _onStepContinue() async {
    bool canProceed = false;

    switch (_currentStep) {
      case 0: // Customer Validation (now using CustomerValidationStep)
        if (_formKeys[_currentStep].currentState?.validate() ?? false) {
          // Get the account type from customer data
          _selectedAccountType = _customerData.accountType;
          canProceed = true;
        }
        break;
      case 1: // Personal/Organization Information
        if (_detailsFormKey.currentState?.validate() ?? false) {
          canProceed = true;
        }
        break;
      case 2: // Review & Confirm
        canProceed = true;
        break;
    }

    if (canProceed) {
      if (_currentStep == 2) {
        _onComplete();
      } else {
        setState(() {
          _currentStep++;
        });
      }
    }
  }

  void _onComplete() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      if (_selectedAccountType == 'Individual') {
        final data = {
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'phone_number': _phoneController.text,
          'email': _emailController.text,
        };
        await _repository.registerIndividual(data);
      }
      if (mounted) {
        _showConfirmationDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating customer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _resetStepper() {
    setState(() {
      _currentStep = 0;
      _selectedAccountType = null;
      _firstNameController.clear();
      _lastNameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _organizationNameController.clear();
      _organizationTypeController.clear();
      _kraPinController.clear();
    });
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Complete'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('The customer account has been successfully created.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetStepper();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomStepper(
      pageTitle: 'Customer Management',
      currentStep: _currentStep,
      onStepContinue: _onStepContinue,
      onComplete: _onComplete,
      onStepBack: () {
        if (_currentStep > 0) {
          setState(() {
            _currentStep--;
          });
        }
      },
      isLoading: _isProcessing,
      steps: [
        CustomStep(
          title: 'Customer Validation',
          content: CustomerValidationStep(
            data: _customerData,
            onDataChanged: (data) {
              setState(() {
                _selectedAccountType = data.accountType;
              });
            },
            formKey: _formKeys[0],
          ),
        ),
        CustomStep(title: 'Customer Details', content: _buildDetailsStep()),
        CustomStep(
          title: 'Review & Confirm',
          content: _buildReviewAndConfirmStep(),
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    if (_selectedAccountType == 'individual') {
      return _buildIndividualForm();
    } else if (_selectedAccountType == 'organization') {
      return _buildOrganizationForm();
    } else {
      return const Center(
        child: Text('Please select an account type in the previous step.'),
      );
    }
  }

  Widget _buildIndividualForm() {
    return Form(
      key: _detailsFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Personal Details',
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                (value?.isEmpty ?? true) ? 'Please enter a first name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                (value?.isEmpty ?? true) ? 'Please enter a last name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                (value?.isEmpty ?? true) ? 'Please enter a phone number' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email Address (Optional)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizationForm() {
    return Form(
      key: _detailsFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Organization Details',
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _organizationNameController,
            decoration: const InputDecoration(
              labelText: 'Organization Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) => (value?.isEmpty ?? true)
                ? 'Please enter an organization name'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _organizationTypeController,
            decoration: const InputDecoration(
              labelText: 'Organization Type',
              border: OutlineInputBorder(),
            ),
            validator: (value) => (value?.isEmpty ?? true)
                ? 'Please enter an organization type'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _kraPinController,
            decoration: const InputDecoration(
              labelText: 'KRA PIN',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                (value?.isEmpty ?? true) ? 'Please enter a KRA PIN' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewAndConfirmStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Your Details',
          style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildReviewDetailItem('ID Type', _customerData.idType ?? 'N/A'),
        _buildReviewDetailItem(
          'ID Number',
          _customerData.idNumber ?? 'N/A',
        ),
        _buildReviewDetailItem(
          'Mobile Number',
          _customerData.mobileNumber ?? 'N/A',
        ),
        const Divider(height: 32),
        if (_selectedAccountType == 'Individual') ...[
          _buildReviewIndividualDetails(),
        ] else if (_selectedAccountType == 'Organization') ...[
          _buildReviewOrganizationDetails(),
        ],
      ],
    );
  }

  Widget _buildReviewIndividualDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReviewDetailItem('Account Type', 'Individual'),
        _buildReviewDetailItem('First Name', _firstNameController.text),
        _buildReviewDetailItem('Last Name', _lastNameController.text),
        _buildReviewDetailItem('Phone Number', _phoneController.text),
        if (_emailController.text.isNotEmpty)
          _buildReviewDetailItem('Email Address', _emailController.text),
      ],
    );
  }

  Widget _buildReviewOrganizationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReviewDetailItem('Account Type', 'Organization'),
        _buildReviewDetailItem(
          'Organization Name',
          _organizationNameController.text,
        ),
        _buildReviewDetailItem(
          'Organization Type',
          _organizationTypeController.text,
        ),
        _buildReviewDetailItem('KRA PIN', _kraPinController.text),
      ],
    );
  }

  Widget _buildReviewDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: GoogleFonts.lato(fontSize: 16))),
        ],
      ),
    );
  }
}
