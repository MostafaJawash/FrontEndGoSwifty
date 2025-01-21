import 'dart:convert';
import 'package:delivery/screens/store.dart';
import 'package:http/http.dart' as http;


Future<List<Product>> searchProducts(String token, String name) async {
  final String apiUrl = "${ApiConstants.baseUrl}/products/search?product=$name";

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

      final products = data
          .map((productJson) {
            try {
              return Product(
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
              );
            } catch (error) {
              print('Error processing product: $productJson, Error: $error');
              return null;
            }
          })
          .whereType<Product>()
          .toList();

      return products;
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
    throw Exception('Failed to load products: $error');
  }
}

Future<List<Store>> searchStoresApi(String token, String name) async {
  final String apiUrl = "${ApiConstants.baseUrl}/stores/search?store=$name";

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