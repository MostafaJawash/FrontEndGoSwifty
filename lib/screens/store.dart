import 'package:shared_preferences/shared_preferences.dart';

class Store {
  final String name;
  final String imageUrl;
  final String description;
  final String id;
  final String address;

  Store(this.id, this.name, this.imageUrl, this.description, this.address);
}

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final double? discount;
  final double quantity;
  Product(this.id, this.name, this.imageUrl, this.price, this.description,
      this.discount, this.quantity);
}

class TokenManager {
  static String? token;
  static String? role;

  static String? firstName;
  static String? lastName;
  static String? email;
  static String? phoneNumber;
  static String? location;
  static String? image;

  static Future<void> saveTokenAndRole(String newToken, String userRole) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', newToken);
      await prefs.setString('role', userRole);
      token = newToken;
      role = userRole;
    } catch (e) {
      print('Error saving token and role: $e');
    }
  }

  static Future<void> saveUserData({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String? location,
    required String? image,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', firstName);
      await prefs.setString('lastName', lastName);
      await prefs.setString('email', email);
      await prefs.setString('phoneNumber', phoneNumber);
      await prefs.setString('location', location ?? '');
      await prefs.setString('image', image ?? '');

      TokenManager.firstName = firstName;
      TokenManager.lastName = lastName;
      TokenManager.email = email;
      TokenManager.phoneNumber = phoneNumber;
      TokenManager.location = location;
      TokenManager.image = image;
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  static Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    role = prefs.getString('role');
    firstName = prefs.getString('firstName');
    lastName = prefs.getString('lastName');
    email = prefs.getString('email');
    phoneNumber = prefs.getString('phoneNumber');
    location = prefs.getString('location');
    image = prefs.getString('image');
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    token = null;
    role = null;
    firstName = null;
    lastName = null;
    email = null;
    phoneNumber = null;
    location = null;
    image = null;
  }
}

class ApiConstants {
  static const String baseUrl = 'http://192.168.1.8:8001/api';
}

class AppImage {
  static const String appImage = 'http://192.168.1.100:8001/storage/';
}

class Authmos {
  static String? _tokenmos;
  static String? _role;
  static String? _firstName;
  static String? _lastName;
  static String? _email;
  static String? _phoneNumber;
  static String? _location;
  static String? _image;

  static String? get tokenmos => _tokenmos;
  static set tokenmos(String? value) {
    _tokenmos = value;
  }

  static String? get role => _role;
  static set role(String? value) {
    _role = value;
  }

  static String? get firstName => _firstName;
  static set firstName(String? value) {
    _firstName = value;
  }

  static String? get lastName => _lastName;
  static set lastName(String? value) {
    _lastName = value;
  }

  static String? get email => _email;
  static set email(String? value) {
    _email = value;
  }

  static String? get phoneNumber => _phoneNumber;
  static set phoneNumber(String? value) {
    _phoneNumber = value;
  }

  static String? get location => _location;
  static set location(String? value) {
    _location = value;
  }

  static String? get image => _image;
  static set image(String? value) {
    _image = value;
  }

  static void saveAllData({
    String? mos,
    String? role,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? location,
    String? image,
  }) {
    _tokenmos = mos;
    _role = role;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phoneNumber = phoneNumber;
    _location = location;
    _image = image;
  }

  static void loadAllData() {}

  static void clearAllData() {
    _tokenmos = null;
    _role = null;
    _firstName = null;
    _lastName = null;
    _email = null;
    _phoneNumber = null;
    _location = null;
    _image = null;
  }
}
