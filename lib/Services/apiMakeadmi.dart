import 'package:delivery/screens/store.dart';
import 'package:http/http.dart' as http;

Future<bool> makeAdmin({
  required String phoneNumber,
  required String token,
}) async {
  final url =
      Uri.parse('${ApiConstants.baseUrl}/make-admin?phone_number=$phoneNumber');

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('تم تحويل المستخدم إلى مشرف بنجاح!');
      return true;
    } else {
      print('فشل في تحويل المستخدم. كود الحالة: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('حدث خطأ أثناء تحويل المستخدم: $e');
    return false;
  }
}