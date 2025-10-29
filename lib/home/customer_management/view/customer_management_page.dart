import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widget/custom_stepper.dart';
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
  final _verifyFormKey = GlobalKey<FormState>();
  final _detailsFormKey = GlobalKey<FormState>();

  // Verification Controllers
  String? _selectedIdType; // This will now store the value, e.g., "national_id"
  final _verificationIdNumberController = TextEditingController();

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

  // ID Type Maps
  final Map<String, String> _individualIdTypes = {
    'National ID': 'national_id',
    'Passport': 'passport',
    'Alien ID': 'alien_id',
    'KRA PIN': 'kra_pin',
  };

  final Map<String, String> _organizationIdTypes = {
    'Company Registration Number': 'company_reg_no',
    'KRA PIN': 'kra_pin',
  };

  @override
  void dispose() {
    _verificationIdNumberController.dispose();
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
      case 0: // Registration Type
        canProceed = true;
        break;
      case 1: // Account Type
        if (_selectedAccountType != null) {
          canProceed = true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select an account type.')),
          );
        }
        break;
      case 2: // Verify Customer
        if (_verifyFormKey.currentState?.validate() ?? false) {
          setState(() {
            _isProcessing = true;
          });
          try {
            await _repository.searchCustomer(
              _selectedIdType!,
              _verificationIdNumberController.text,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('A customer with this ID already exists.'),
                backgroundColor: Colors.red,
              ),
            );
          } catch (e) {
            canProceed = true;
          }
          setState(() {
            _isProcessing = false;
          });
        }
        break;
      case 3: // Personal/Organization Information
        if (_detailsFormKey.currentState?.validate() ?? false) {
          canProceed = true;
        }
        break;
      case 4: // Review & Confirm
        canProceed = true;
        break;
    }

    if (canProceed) {
      if (_currentStep == 4) {
        _onComplete();
      } else {
        setState(() {
          _currentStep++;
        });
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _onComplete() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      Map<String, dynamic> customerData = {
        'id_type': _selectedIdType,
        'id_number': _verificationIdNumberController.text,
        'type': _selectedAccountType,
      };

      if (_selectedAccountType == 'individual') {
        customerData.addAll({
          'name': '${_firstNameController.text} ${_lastNameController.text}',
          'phone_number': _phoneController.text,
          'email': _emailController.text,
        });
      } else {
        customerData.addAll({
          'name': _organizationNameController.text,
          'organization_type': _organizationTypeController.text,
          'kra_pin': _kraPinController.text,
        });
      }

      await _repository.createCustomer(customerData);
      _showConfirmationDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating customer: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
      _selectedIdType = null;
      _verificationIdNumberController.clear();
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
      currentStep: _currentStep,
      onStepContinue: _onStepContinue,
      onStepCancel: _onStepCancel,
      onComplete: _onComplete,
      isLoading: _isProcessing,
      steps: [
        CustomStep(
          title: 'Registration Type',
          content: _buildRegistrationTypeStep(),
        ),
        CustomStep(title: 'Account Type', content: _buildAccountTypeStep()),
        CustomStep(
          title: 'Verify Customer',
          content: _buildVerifyCustomerStep(),
        ),
        CustomStep(title: 'Customer Details', content: _buildDetailsStep()),
        CustomStep(
          title: 'Review & Confirm',
          content: _buildReviewAndConfirmStep(),
        ),
      ],
    );
  }

  Widget _buildRegistrationTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Registration Type',
          style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        RadioListTile<String>(
          title: const Text('Offline Customer Registration'),
          value: 'offline',
          groupValue: 'offline',
          onChanged: (String? value) {},
        ),
      ],
    );
  }

  Widget _buildAccountTypeStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Register Customer',
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Register a customer in the NairobiPay revenue management system. The customer account will be used for all county services required by the customer. Determine whether the account is for an individual or an organization. Get the identification details of individual or organization to proceed with the account creation.',
            style: GoogleFonts.lato(fontSize: 16),
          ),
          const SizedBox(height: 24),
          _buildAccountTypeOption(
            title: 'Individual Account',
            subtitle:
                'Create an account for natural persons, both Kenyan Citizens and foreigners. this account is also suitable for unregistered/informal businesses',
            value: 'individual',
          ),
          const SizedBox(height: 16),
          _buildAccountTypeOption(
            title: 'Organization Account',
            subtitle:
                'Create an account for a registered organization, including Companies, Co-opertives, Churches, Self help groups. Registered organizations will usually have a registered certificate issued by a government authority and have a KRA PIN.',
            value: 'organization',
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTypeOption({
    required String title,
    required String subtitle,
    required String value,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedAccountType != value) {
            _selectedAccountType = value;
            _selectedIdType = null; // Reset the ID type
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selectedAccountType == value
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: _selectedAccountType == value
                ? Theme.of(context).primaryColor
                : Colors.grey.shade400,
            width: _selectedAccountType == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedAccountType,
              onChanged: (String? val) {
                setState(() {
                  if (_selectedAccountType != val) {
                    _selectedAccountType = val;
                    _selectedIdType = null; // Reset the ID type
                  }
                });
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyCustomerStep() {
    final Map<String, String> currentIdTypes =
        _selectedAccountType == 'individual'
            ? _individualIdTypes
            : _organizationIdTypes;

    return Form(
      key: _verifyFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verify Customer Existence',
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Select an ID type and enter the ID number to check if the customer already has an account.',
            style: GoogleFonts.lato(fontSize: 16),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'ID Type',
              border: OutlineInputBorder(),
            ),
            value: _selectedIdType,
            items: currentIdTypes.entries
                .map(
                  (entry) => DropdownMenuItem(
                    value: entry.value,
                    child: Text(entry.key),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedIdType = value;
              });
            },
            validator: (value) =>
                value == null ? 'Please select an ID type.' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _verificationIdNumberController,
            decoration: const InputDecoration(
              labelText: 'ID Number',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an ID number.';
              }
              return null;
            },
          ),
        ],
      ),
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
              border: OutlineInputBorder(),           ),
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
    // Helper to find the label from the value
    String getIdTypeLabel(String? value) {
      if (value == null) return 'N/A';
      final allIdTypes = {..._individualIdTypes, ..._organizationIdTypes};
      for (var entry in allIdTypes.entries) {
        if (entry.value == value) {
          return entry.key;
        }
      }
      return value; // Fallback to the value itself
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Your Details',
          style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildReviewDetailItem('ID Type', getIdTypeLabel(_selectedIdType)),
        _buildReviewDetailItem(
          'ID Number',
          _verificationIdNumberController.text,
        ),
        const Divider(height: 32),
        if (_selectedAccountType == 'individual') ...[
          _buildReviewIndividualDetails(),
        ] else if (_selectedAccountType == 'organization') ...[
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
