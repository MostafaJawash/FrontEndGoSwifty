import 'dart:convert';
import 'package:delivery/screens/store.dart';
import 'package:http/http.dart' as http;

Future<String> likeOrDislikeProduct({
  required String token,
  required String productId,
}) async {
  final url = Uri.parse('${ApiConstants.baseUrl}/like-dislike/$productId');

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      return "Liked";
    } else if (response.statusCode == 200) {
      return "Disliked";
    } else {
      throw Exception(
          'Unexpected response: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    throw Exception('Error while performing like/dislike: $e');
  }
}

class ProductMapper {
  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      json['id'].toString(),
      json['name'] ?? '',
      json['image'] ?? '',
      double.tryParse(json['price'] ?? '0') ?? 0.0,
      json['description'] ?? '',
      double.tryParse(json['discount']?.toString() ?? '0') ?? 0.0,
      double.tryParse(json['quantity']?.toString() ?? '0') ?? 0.0,
    );
  }
}

Future<List<Product>> fetchLikedProducts(String token) async {
  final url = Uri.parse('${ApiConstants.baseUrl}/liked-products');

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<Product> products = (data['data'] as List)
          .map((item) => ProductMapper.fromJson(item['product']))
          .toList();

      return products;
    } else {
      throw Exception(
          "Unexpected response: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    throw Exception("Error while fetching liked products: $e");
  }
}
