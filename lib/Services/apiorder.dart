import 'dart:convert';
import 'package:delivery/screens/store.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> createOrder(
  String token, {
  required String productId,
  required double quantity,
  required String paymentMethod,
  required String orderLocation,
}) async {
  String apiUrl = "${ApiConstants.baseUrl}/orders";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "product_id": productId,
        "quantity": quantity,
        "payment_method": paymentMethod,
        "location": orderLocation,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      final int orderId = data['order']['id'];

      return {
        'message': data['message'],
        'order': data['order'],
        'orderId': orderId,
      };
    } else if (response.statusCode == 400) {
      final errorData = json.decode(response.body) as Map<String, dynamic>;
      throw Exception(errorData['message'] ?? 'Bad Request');
    } else {
      throw Exception('Unexpected error: ${response.statusCode}');
    }
  } catch (error) {
    throw ('$error');
  }
}

Future<void> deleteOrder(String token, int orderId) async {
  final String apiUrl = "${ApiConstants.baseUrl}/orders/$orderId";

  try {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Order deleted successfully.');
    } else if (response.statusCode == 404) {
      final errorData = json.decode(response.body) as Map<String, dynamic>;
      throw Exception(errorData['message'] ?? 'Order not found.');
    } else {
      throw Exception('Failed to delete order: ${response.statusCode}');
    }
  } catch (error) {
    throw ('Error deleting order: $error');
  }
}

class ApiUpdateOrder {
  final String baseUrl = ApiConstants.baseUrl;

  Future<Map<String, dynamic>> updateOrder({
    required String orderId,
    required int quantity,
    required String paymentMethod,
    required String location, 
    required String token,
    required String orderProductId, 
  }) async {
    final url = Uri.parse('$baseUrl/orders/$orderId');

    final body = {
      "quantity": quantity,
      "payment_method": paymentMethod,
      "location": location,
      "orderProduct_id": orderProductId, 
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
      
        return {'message': 'Order updated successfully'};
      } else {
        throw Exception(
            'Failed to update order. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error updating order: $error');
    }
  }
}
  Future<List<Map<String, dynamic>>> fetchOrders(String token) async {
    const String url = '${ApiConstants.baseUrl}/orders/';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return (data['orders'] as List<dynamic>).map((order) {
          return {
            'id': order['id'],
            'user_id': order['user_id'],
            'total_price': order['total_price'],
            'payment_method': order['payment_method'],
            'location': order['location'],
            'status': order['status'],
            'order_products':
                (order['order_products'] as List<dynamic>).map((product) {
              return {
                'id': product['id'],
                'order_id': product['order_id'] ?? 0,
                'product_id': product['product_id'] ?? 0,
                'quantity': product['quantity'] ?? 0,
                'price': product['price'] ?? 0.0,
                'product_details': {
                  'id': product['product']['id'] ?? 0,
                  'store_id': product['product']['store_id'] ?? 0,
                  'name': product['product']['name'] ?? 'Unknown',
                  'description': product['product']['description'] ?? '',
                  'price': product['product']['price'] ?? 0.0,
                  'image': product['product']['image'],
                  'discount': product['product']['discount'] ?? 0,
                  'quantity': product['product']['quantity'] ?? 0,
                },
              };
            }).toList(),
          };
        }).toList();
      } else {
        throw Exception(
            'Failed to fetch orders. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }