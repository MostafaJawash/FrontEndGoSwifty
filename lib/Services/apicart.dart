import 'dart:convert';
import 'package:delivery/screens/globals.dart';
import 'package:delivery/screens/store.dart';
import 'package:http/http.dart' as http;




class CartApi {
  static const String baseUrl = '${ApiConstants.baseUrl}/cart';
  final String token;

  CartApi(this.token);

 Future<bool> addToCart({
    required String productId,
    required double quantity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
           if (sessionCookie != null) 'Cookie': sessionCookie!,
        },
        body: jsonEncode({
          "product_id": double.parse(productId),
          "quantity": quantity,
        }),
      );

      
      print('Request Body: ${jsonEncode({
        "product_id": double.parse(productId),
        "quantity": quantity,
      })}');
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }




static Future<Map<String, dynamic>> deleteCartItem(int itemId, String token) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/cart/$itemId');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
         if (sessionCookie != null) 'Cookie': sessionCookie!,
      };

      final response = await http.delete(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        print('فشل في حذف المنتج. رمز الحالة: ${response.statusCode}');
        return {'error': 'حدث خطأ أثناء حذف المنتج.'};
      }
    } catch (e) {
      print('حدث خطأ أثناء طلب الحذف: $e');
      return {'error': 'حدث خطأ غير متوقع.'};
    }
  }
}










class CartItem {
  final int id;
  final int quantity;
  final double price;
  final Product product;

  CartItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
      product: Product.fromJson(json['product']),
    );
  }
}

class Product {
  final int id;
  final int storeId;
  final String name;
  final String description;
  final String price;
  final String image;
  final String discount;
  final int quantity;

  Product({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.discount,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      storeId: json['store_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      discount: json['discount'],
      quantity: json['quantity'],
    );
  }
}class ShowCartApi {
  final String baseUrl = '${ApiConstants.baseUrl}/cart';
  

  Future<List<CartItem>> getCart(String token, ) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        if (sessionCookie != null) 'Cookie': sessionCookie!,
      };

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final cartItems = jsonData['Cart'] as Map<String, dynamic>?;

        if (cartItems == null || cartItems.isEmpty) {
          print('لا توجد عناصر في السلة.');
          return [];
        }

        return cartItems.values
            .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        print('فشل في تحميل السلة. رمز الحالة: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('حدث خطأ أثناء جلب البيانات: $e');
      return [];
    }
  }
}
         












Future<Map<String, dynamic>> placeOrder(String token, String paymentMethod, String location) async {
  final url = Uri.parse('http://192.168.1.8:8001/api/cart/placeOrder');
  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
     if (sessionCookie != null) 'Cookie': sessionCookie!,
  };
  final body = jsonEncode({
    'payment_method': paymentMethod,
    'location': location,
  });

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // تحويل الاستجابة إلى JSON
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      print('فشل في إنشاء الطلب. رمز الحالة: ${response.statusCode}');
      return {'error': 'حدث خطأ أثناء إنشاء الطلب.'};
    }
  } catch (e) {
    print('حدث خطأ أثناء طلب إنشاء الطلب: $e');
    return {'error': 'حدث خطأ غير متوقع.'};
  }
}