import 'dart:convert';
import 'package:delivery/screens/globals.dart';
import 'package:delivery/screens/store.dart';
import 'package:http/http.dart' as http;

Future<List<Store>> fetchStoresApi(String token) async {
  String apiUrl = "${ApiConstants.baseUrl}/stores";

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      var cookies = response.headers['set-cookie'];
      sessionCookie = "$cookies";
      print("$cookies");
      return data.map((storeJson) {
        return Store(
          storeJson['id'].toString(),
          storeJson['name'],
          storeJson['image'] ?? '',
          storeJson['description'] ?? '',
          storeJson['address'] ?? '',
        );
      }).toList();
    } else {
      throw Exception('Failed to load stores: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Failed to load stores: $error');
  }
}

Future<List<Product>> fetchProducts(String token, String storeId) async {
  final String apiUrl = "${ApiConstants.baseUrl}/stores/$storeId/products";

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final products = (data['store']['products'] as List<dynamic>)
          .map((productJson) => Product(
                productJson['id'].toString(),
                productJson['name'] ?? 'Unnamed Product',
                productJson['image'] ?? '',
                double.tryParse(productJson['price']?.toString() ?? '0.0') ??
                    0.0,
                productJson['description'] ?? 'No description available',
                double.tryParse(productJson['discount']?.toString() ?? '0.0') ??
                    0.0,
                double.tryParse(productJson['quantity']?.toString() ?? '0.0') ??
                    0.0,
              ))
          .toList();

      return products;
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Failed to load products: $error');
  }
}
