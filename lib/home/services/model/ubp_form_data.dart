import '../../../models/customer_validation_data.dart';

class UBPFormData {
  // Customer validation
  CustomerValidationData customerData = CustomerValidationData();

  // Business Category
  String? brsNumber;
  String? businessNature; // 'Registered' or 'Unregistered'

  // Business Details
  String? businessName;
  String? streetName;
  String? plotNumber;
  String? buildingName;
  String? floorNumber;
  String? roomStallNumber;

  // Business Activity
  String? businessIndustry;
  String? businessCategory;
  String? businessSubCategory;
  String? businessActivity;

  // Business Contacts
  String? email;
  String? ownerMobileNumber;
  String? poBox;
  String? postalCode;
  String? businessRole;
  String? contactPersonId;
  String? contactPersonName;
  String? contactPersonPhone;
  String? contactPersonEmail;

  // Payment
  String? paymentPlan; // 'Full' or 'Installment'
  String? paymentMethod; // 'M-Pesa', 'Bank', 'Card'

  UBPFormData();
}
