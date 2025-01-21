import 'dart:convert';
import 'dart:io';
import 'package:delivery/screens/store.dart';
import 'package:http/http.dart' as http;

class ApiLogin {
  static const String baseUrl = '${ApiConstants.baseUrl}';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  static Future<Map<String, dynamic>> login(
      String phone, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'phone_number': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('user') &&
            responseData.containsKey('token')) {
  
          final String token = responseData['token'];
          final String role = responseData['user']['role'];
          final user = responseData['user'];

       
          TokenManager.saveTokenAndRole(token, role);

          TokenManager.saveUserData(
            firstName:
                user['first_name'] ?? '',
            lastName:
                user['last_name'] ?? '', 
            email: user['email'] ?? '', 
            phoneNumber:
                user['phone_number'] ?? '', 
            location:
                user['location'], 
            image: user['image'], 
          );

          Authmos.saveAllData(
            mos: responseData['token']!,
            role: responseData['user']['role'],
            firstName: user['first_name'] ?? '',
            lastName: user['last_name'] ?? '',
            email: user['email'] ?? '',
            phoneNumber: user['phone_number'] ?? '',
            location: user['location'],
            image: user['image'],
          );

          return {
            'success': true,
            'message': 'Login successful',
            'user': user,
            'token': token,
            'role': role,
          };
        } else {
          print('Invalid response structure: $responseData');
          return {'success': false, 'message': 'Invalid response structure'};
        }
      } else {
        print('Error status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {
          'success': false,
          'message': response.statusCode == 401
              ? 'Invalid credentials'
              : 'Server error: ${response.statusCode}',
        };
      }
    } catch (error) {
      print('Network error: $error');
      return {
        'success': false,
        'message': 'Network error: ${error.toString()}'
      };
    }
  }
}

class ApiRegister {
  static const String baseUrl =
      "${ApiConstants.baseUrl}"; 

  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final url = Uri.parse('$baseUrl/register'); 

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', 
        },
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phoneNumber,
          'key': '+963', 
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('user') &&
            responseData.containsKey('token')) {
          final String token = responseData['token'];
          final String role =
              responseData['user']['role'] ?? ''; 
               final user = responseData['user'];

          TokenManager.saveTokenAndRole(token, role);
                    Authmos.saveAllData(
            mos: responseData['token']!,
            role: responseData['user']['role'],
            firstName: user['first_name'] ?? '',
            lastName: user['last_name'] ?? '',
            email: user['email'] ?? '',
            phoneNumber: user['phone_number'] ?? '',
            location: user['location'],
            image: user['image'],
          );
          return {
            'success': true,
            'message': 'Registration successful',
            'user': responseData['user'],
            'token': token,
            'role': role,
          };
        } else {
          print('Invalid response structure: $responseData');
          return {'success': false, 'message': 'Invalid response structure'};
        }
      } else {
        print('Error status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {
          'success': false,
          'message': 'Registration failed. Please try again later.',
        };
      }
    } catch (error) {
      print('Network error: $error');
      return {
        'success': false,
        'message': 'Network error: ${error.toString()}'
      };
    }
  }
}



Future<void> logout(String token) async {
  String apiUrl = "${ApiConstants.baseUrl}/logout";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 204) {
      print("Logout successful");
      await TokenManager.clearUserData(); 
    } else { 
      throw Exception(
          'Failed to logout: ${response.statusCode} ${response.body}');
    }
  } catch (error) {
    throw ('Error during logout: $error');
  }
}



class ApiUpdateProfile {
  static const String baseUrl = "${ApiConstants.baseUrl}";

  static Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String location,
    File? image,
  }) async {
    final url = Uri.parse('$baseUrl/update-profile');

    try {
    
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['first_name'] = firstName
        ..fields['last_name'] = lastName
        ..fields['email'] = email
        ..fields['phone_number'] = phoneNumber
        ..fields['location'] = location;

    
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decodedData = jsonDecode(responseData);

        final user = decodedData['user'];
        TokenManager.saveUserData(
          firstName: user['first_name'],
          lastName: user['last_name'],
          email: user['email'],
          phoneNumber: user['phone_number'],
          location: user['location'],
          image: user['image'],
        );

        return {
          'success': true,
          'message': decodedData['message'],
          'user': decodedData['user'],
        };
      } else {
        return {
          'success': false,
          'message': 'Error: ${response.statusCode}',
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'Network error: ${error.toString()}',
      };
    }
  }
}
