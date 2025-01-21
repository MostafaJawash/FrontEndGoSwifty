import 'dart:io';
import 'package:delivery/screens/store.dart';
import 'package:http/http.dart' as http;

Future<void> createProduct({
  required String idStore,
  required String token,
  required String name,
  required String description,
  required double price,
  required int quantity,
  required File image,
}) async {
  final url =
      Uri.parse('${ApiConstants.baseUrl}/store/$idStore/create-product/');
  final headers = {
    'Authorization': 'Bearer $token',
  };

  try {
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..fields['name'] = name
      ..fields['description'] = description
      ..fields['price'] = price.toString()
      ..fields['quantity'] = quantity.toString();

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      print('تم إنشاء المنتج بنجاح!');
    } else {
      print('فشل في إنشاء المنتج: ${response.statusCode}');
      print('الرد: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('خطأ أثناء إنشاء المنتج: $e');
  }
}

Future<bool> updateProduct({
  required String id,
  required String token,
  required String name,
  required String description,
  required double price,
  required int quantity,
  required File image,
}) async {
  final url = Uri.parse('${ApiConstants.baseUrl}/update-product/$id');

  try {
    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['description'] = description
      ..fields['price'] = price.toString()
      ..fields['quantity'] = quantity.toString();

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('تم تحديث المنتج بنجاح!');
      return true;
    } else {
      print('فشل في تحديث المنتج. كود الحالة: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('حدث خطأ أثناء تحديث المنتج: $e');
    return false;
  }
}

Future<bool> deleteProduct({
  required String productId,
  required String token,
}) async {
  final url = Uri.parse('${ApiConstants.baseUrl}/delete-product/$productId');

  try {
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('تم حذف المنتج بنجاح!');
      return true;
    } else {
      print('فشل في حذف المنتج. كود الحالة: ${response.statusCode}');
      print('الرد: ${response.body}');
      return false;
    }
  } catch (e) {
    print('حدث خطأ أثناء حذف المنتج: $e');
    return false;
  }
}
