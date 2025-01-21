import 'dart:convert';
import 'package:http/http.dart' as http;

class Apiadminorder {
  
   final String baseUrl = "http://192.168.1.8:8001/api";

 
  Future<dynamic> acceptOrder(String token, String orderId) async {
    final url = Uri.parse("$baseUrl/accepted/$orderId");

    try {
      final response = await http.get(
        url,
      headers: {
  "Authorization": "Bearer $token",
  "Content-Type": "application/json",
},
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data; 
      } else if (response.statusCode == 404) {
        final data = jsonDecode(response.body);
        return {"": data["message"]}; 
      } else {
        return {"error": "Unexpected status code: ${response.statusCode}"};
      }
    } catch (e) {
      return {"error": "Network error: $e"};
    }
  }



   Future<dynamic> declineOrder({
    required String token,
    required int orderId,
    required String reason,
  }) async {
    final url = Uri.parse("$baseUrl/declined/$orderId?reason=$reason");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        return {"error": data["message"] ?? "Unexpected error"};
      }
    } catch (e) {
      return {"error": "Network error: $e"};
    }
  }
}
