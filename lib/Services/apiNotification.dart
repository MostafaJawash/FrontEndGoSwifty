import 'dart:convert';

import 'package:delivery/screens/store.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final String apiUrl = "${ApiConstants.baseUrl}/notification/number";

  Future<int?> fetchNotificationNumber(String token) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse('$apiUrl'), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data['number'] as int?;
      } else {
        print('خطأ في الطلب: ${response.statusCode}');
      }
    } catch (e) {
      print('حدث خطأ: $e');
    }
    return null;
  }
}
class fetchNotificationService {
  final String apiUrl = "${ApiConstants.baseUrl}/notifications";

  Future<List<Map<String, dynamic>>?> fetchNotifications(String token) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['notifications']);
      } else {
        print('خطأ في الطلب: ${response.statusCode}');
      }
    } catch (e) {
      print('حدث خطأ: $e');
    }
    return null;
  }
}
