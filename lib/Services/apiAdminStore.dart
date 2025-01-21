import 'dart:convert';
import 'dart:io';
import 'package:delivery/screens/store.dart';
import 'package:http/http.dart' as http;

Future<void> createStore({
  required String token,
  required String name,
  required File image,
  required String description,
  required String address,
}) async {
  final url = Uri.parse('${ApiConstants.baseUrl}/create-store');

  try {
    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['description'] = description
      ..fields['address'] = address
      ..files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);
      print('Store created successfully: $jsonResponse');
    } else {
      print('Failed to create store. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<bool> updateStore({
  required String token,
  required String storeId,
  required String name,
  required String address,
  required String description,
  required File image,
}) async {
  final url = Uri.parse('${ApiConstants.baseUrl}/update-store/$storeId');

  try {
    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['address'] = address
      ..fields['description'] = description
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);
      print('Store updated successfully: $jsonResponse');
      return true;
    } else {
      print('Failed to update store. Status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

Future<bool> deleteStore(
    {required String token, required String storeId}) async {
  final Uri url = Uri.parse('${ApiConstants.baseUrl}/delete-store/$storeId');

  try {
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('Store deleted successfully');
      return true;
    } else {
      print('Failed to delete store. Status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}
