import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SettingsController with ChangeNotifier {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int amountDay = 0;
  int soakTime = 0;
  int wateringPeriod = 0;
  int setTemperature = 0;
  int temperature = 0;


  Future<void> fetchDefaultSettings() async {
    final url = Uri.parse('http://210.246.215.73:4000/getsettings'); // เปลี่ยน URL ตามเซิร์ฟเวอร์จริง

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      startTime = responseData['data'] != null && responseData['data']['startTime'] != null
    ? _parseTime(responseData['data']['startTime'])
    : TimeOfDay(hour: 0, minute: 0); 

endTime = responseData['data'] != null && responseData['data']['endTime'] != null
    ? _parseTime(responseData['data']['endTime'])
    : TimeOfDay(hour: 0, minute: 0);
amountDay = responseData['data'] != null && responseData['data']['day'] != null
    ? responseData['data']['day']
    : 0;

soakTime = responseData['data'] != null && responseData['data']['soak'] != null
    ? responseData['data']['soak']
    : 0;

wateringPeriod = responseData['data'] != null && responseData['data']['minute'] != null
    ? responseData['data']['minute']
    : 0;

setTemperature = responseData['data'] != null && responseData['data']['temperature'] != null
          ? responseData['data']['temperature']
          : 0;

      notifyListeners();

    } else {
      throw Exception('Failed to load default settings');
    }
  }

  // แปลง String "HH:mm:ss" เป็น TimeOfDay
  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
