import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

class ApiService {
  // TODO: Move to env and make multi env
  final String _baseUrl = "http://192.168.102.95/uat/nrs";
  static const bool useMockData = true; // Set to false to use actual API

  Future<dynamic> get(String url) async {
    if (useMockData) {
      return _handleMockGet(url);
    }

    final response = await http.get(Uri.parse('$_baseUrl$url'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to GET from $url');
    }
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    if (useMockData) {
      return _handleMockPost(url, body);
    }

    final response = await http.post(
      Uri.parse('$_baseUrl$url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to POST to $url');
    }
  }

  Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body,
  ) async {
    if (useMockData) {
      return _handleMockPut(url, body);
    }

    final response = await http.put(
      Uri.parse('$_baseUrl$url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to PUT to $url');
    }
  }

  Future<Map<String, dynamic>> delete(String url) async {
    if (useMockData) {
      return _handleMockDelete(url);
    }

    final response = await http.delete(Uri.parse('$_baseUrl$url'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to DELETE from $url');
    }
  }

  Future<dynamic> _handleMockGet(String url) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (url.startsWith('/adminauth/external/user/kra/id/')) {
      final idNumber = url.split('/').last;
      if (idNumber == '12345678') {
        return {
          'success': true,
          'data': {
            'name': 'John Doe',
            'phone_number': '123-456-7890',
            'email': 'john.doe@example.com',
          },
        };
      } else {
        throw Exception('Customer not found');
      }
    } else if (url.startsWith('/adminauth/external/user/kra/real/pin/')) {
      final pin = url.split('/').last;
      if (pin == 'A000123456B') {
        return {
          'success': true,
          'data': {
            'business_name': 'Test Business',
            'kra_pin': 'A000123456B',
            'contact_person': 'Jane Doe',
          },
        };
      } else {
        throw Exception('Business not found');
      }
    }

    switch (url) {
      case '/services':
        return {
          'services': [
            {
              'id': '1',
              'name': 'Business Permit',
              'description': 'Apply for a new business permit.',
            },
            {
              'id': '2',
              'name': 'Parking Ticket',
              'description': 'Pay for a parking ticket.',
            },
            {
              'id': '3',
              'name': 'Land Rates',
              'description': 'Pay for your land rates.',
            },
            {
              'id': '4',
              'name': 'Construction Permit',
              'description': 'Apply for a construction permit.',
            },
          ],
        };
      default:
        throw Exception('Mock GET handler not implemented for $url');
    }
  }

  Future<Map<String, dynamic>> _handleMockPost(
    String url,
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    switch (url) {
      case '/adminauth/auth/login':
        final username = body['username'];
        final password = body['password'];
        if (username == 'test' && password == 'password') {
          return {'success': true, 'token': 'mock-jwt-token-string'};
        } else {
          return {'success': false, 'message': 'Invalid credentials'};
        }
      case '/adminauth/auth/verify':
        final otp = body['otp'];
        if (otp == '1234') {
          return {'success': true, 'token': 'mock-jwt-token-string'};
        } else {
          return {'success': false, 'message': 'Invalid OTP'};
        }
      case '/auth/individual/register':
        return {'success': true, 'message': 'Individual registered successfully'};
      case '/api/e-verify':
        final documentNumber = body['document_number'];
        if (documentNumber == 'UBP021739') {
          return {
            "document": {
              "id": "2e064388-d88a-4ac9-b627-9fbfd4392300",
              "created_at": "2025-09-19T11:47:22.916505Z",
              "updated_at": "2025-09-19T11:47:22.916534Z",
              "is_archived": false,
              "document_number": "UBP021739",
              "application_number": "TLA066103",
              "application_data": {
                "po_box": "",
                "cust_no": "2020_74282",
                "kra_pin": "",
                "plot_no": "3734/197",
                "floor_no": "1",
                "stall_no": "C3",
                "cust_name": "DAVACC TECH LIMITED",
                "ward_code": "047002001",
                "ward_name": "Kilimani",
                "ubp_amount": "237,840",
                "street_name": "Ralph bunche rd",
                "license_type": "Official",
                "owner_mobile": "",
                "payment_plan": "Annual",
                "building_name": "Elgon c3, Ralph Bunche Rd",
                "business_desc": "",
                "business_name": "DAVACC TECH LIMITED",
                "company_email": "waruid@gmail.com",
                "owner_address": "13783",
                "businessreg_no": "PVT-AAABAU9",
                "contact_person": "DAVID  WARUI MUTHAMI",
                "owner_postcode": "00100",
                "subcounty_code": "047002000",
                "subcounty_name": "Dagoretti North",
                "subsidiary_name": "Westlands Branch",
                "application_date": "02/29/24",
                "contact_mobileno": "0724872300",
                "contactperson_id": "22040031",
                "application_stage": "SBPInspection",
                "UBP_Register_Lines": [
                  {
                    "amount": "120,000",
                    "ubp_code": "100",
                    "ubp_name": "SBP",
                    "brim_desc":
                        "800 INDUSTRIAL PLANTS, FACTORIES, WORKSHOPS, CONTRACTORS ",
                    "fa_category_desc":
                        "Medium food industrial plant with over 51-100 employees ",
                    "parameter1_value": "100",
                    "parameter2_value": "0",
                    "ubpactivity_Code": "31-33",
                    "ubpactivity_name": "Manufacturing ",
                    "inspection_status": " ",
                    "inspection_comment": "",
                    "parameter1_caption": "No of employees",
                    "parameter2_caption": "",
                    "ubpsubcategory_code": "311",
                    "ubpsubcategory_name": "Food Processing ",
                    "ubpsubcategory2_code": "3115",
                    "ubpsubcategory2_name": "Dairy Product Manufacturing ",
                    "ubpsubcategory3_code": "31151",
                    "ubpsubcategory3_name":
                        "Dairy Product (except Frozen) Manufacturing "
                  },
                  {
                    "amount": "50,000",
                    "ubp_code": "200",
                    "ubp_name": "Fire",
                    "brim_desc": "",
                    "fa_category_desc": "",
                    "parameter1_value": "0",
                    "parameter2_value": "0",
                    "ubpactivity_Code": "SF",
                    "ubpactivity_name": "",
                    "inspection_status": " ",
                    "inspection_comment": "",
                    "parameter1_caption": "",
                    "parameter2_caption": "",
                    "ubpsubcategory_code": "SF_01",
                    "ubpsubcategory_name": "",
                    "ubpsubcategory2_code": "SF_014",
                    "ubpsubcategory2_name": "",
                    "ubpsubcategory3_code": "SF_0141",
                    "ubpsubcategory3_name": ""
                  },
                  {
                    "amount": "2,000",
                    "ubp_code": "400",
                    "ubp_name": "Pest Control",
                    "brim_desc": "",
                    "fa_category_desc": "",
                    "parameter1_value": "0",
                    "parameter2_value": "0",
                    "ubpactivity_Code": "SF",
                    "ubpactivity_name": "",
                    "inspection_status": " ",
                    "inspection_comment": "",
                    "parameter1_caption": "",
                    "parameter2_caption": "",
                    "ubpsubcategory_code": "SF_01",
                    "ubpsubcategory_name": "",
                    "ubpsubcategory2_code": "SF_014",
                    "ubpsubcategory2_name": "",
                    "ubpsubcategory3_code": "SF_0141",
                    "ubpsubcategory3_name": ""
                  },
                  {
                    "amount": "30,000",
                    "ubp_code": "800",
                    "ubp_name": "Food Hygiene",
                    "brim_desc": "",
                    "fa_category_desc": "",
                    "parameter1_value": "0",
                    "parameter2_value": "0",
                    "ubpactivity_Code": "SF",
                    "ubpactivity_name": "",
                    "inspection_status": " ",
                    "inspection_comment": "",
                    "parameter1_caption": "",
                    "parameter2_caption": "",
                    "ubpsubcategory_code": "SF_01",
                    "ubpsubcategory_name": "",
                    "ubpsubcategory2_code": "SF_014",
                    "ubpsubcategory2_name": "",
                    "ubpsubcategory3_code": "SF_0141",
                    "ubpsubcategory3_name": ""
                  },
                  {
                    "amount": "35,840",
                    "ubp_code": "900",
                    "ubp_name": "Advertisement",
                    "brim_desc": "",
                    "fa_category_desc": "ABOVE CANOPY Illuminated",
                    "parameter1_value": "2",
                    "parameter2_value": "2",
                    "ubpactivity_Code": "SF",
                    "ubpactivity_name": "Small Format",
                    "inspection_status": " ",
                    "inspection_comment": "",
                    "parameter1_caption": "Length",
                    "parameter2_caption": "Width",
                    "ubpsubcategory_code": "SF_01",
                    "ubpsubcategory_name": "Signboard",
                    "ubpsubcategory2_code": "SF_015",
                    "ubpsubcategory2_name": "ABOVE CANOPY Illuminated",
                    "ubpsubcategory3_code": "SF_0151",
                    "ubpsubcategory3_name": "ABOVE CANOPY Illuminated"
                  }
                ],
                "nature_of_business": "Registered/Formal",
                "contact_person_role": "DIRECTOR",
                "contactperson_email": "waruid@gmail.com"
              },
              "issue_date": "2024-03-07",
              "expiry_date": "2025-03-06",
              "file_url": null,
              "status": "Valid",
              "status_comment": null,
              "status_date": null,
              "document_type": 1,
              "source_register": null
            },
            "invoices": [],
            "payments": []
          };
        } else {
          return {
            'valid': false,
            'message': 'Document could not be verified',
            'data': {},
          };
        }
      case '/api/accounts':
        // Check if it is a 'create' request (will have more than 2 keys)
        if (body.containsKey('type') && body.containsKey('name')) {
          // This is a create customer request
          developer.log('Mock API: Creating customer...');
          return {
            'success': true,
            'message': 'Customer created successfully',
            'data': body, // Echo back the data for confirmation
          };
        } else {
          // This is a search customer request
          final idNumber = body['id_number'];
          if (idNumber == '12345678') {
            return {
              'success': true,
              'data': {
                'name': 'John Doe',
                'phone_number': '123-456-7890',
                'email': 'john.doe@example.com',
              },
            };
          } else {
            // Simulate customer not found for any other ID
            throw Exception('Customer not found');
          }
        }
      default:
        throw Exception('Mock POST handler not implemented for $url');
    }
  }

  Future<Map<String, dynamic>> _handleMockPut(
    String url,
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return {'status': 'success', 'message': 'PUT request was mocked'};
  }

  Future<Map<String, dynamic>> _handleMockDelete(String url) async {
    await Future.delayed(const Duration(seconds: 1));
    return {'status': 'success', 'message': 'DELETE request was mocked'};
  }
}
