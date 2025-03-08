import 'package:http/http.dart' as http;
import 'dart:convert';

class ConnectionController {
  Future<void> addDeviceToServer(String tankId, int userId) async {
    const String url = 'http://210.246.215.73:4000/connection';

    if (userId == 0) {
      print("Error: userId is missing!");
      return;
    }

    final Map<String, dynamic> requestData = {
      'userId': userId,
      'tankId': int.tryParse(tankId) ?? 0, // ป้องกัน error ถ้า tankId ไม่ใช่ตัวเลข
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        print('✅ Device added successfully');
      } else {
        print('❌ Failed to add device: ${response.body}');
      }
    } catch (error) {
      print('❌ Error: $error');
    }
  }
}
