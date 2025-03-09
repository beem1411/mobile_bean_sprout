import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryController with ChangeNotifier {
  int? hisId;
  bool isSaved = false;

  Future<void> saveHistory({
    required DateTime startDate,
    required DateTime endDate,
    required String startTime,
    required String endTime,
    required int amountDay,
    required int wateringPeriod,
    required int round,
    required int soakTime,
    required int frequency, 
  }) async {
    final url = Uri.parse('http://210.246.215.73:4000/addhistory');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({ 
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'startTime': startTime,
        'endTime': endTime,
        'amountDay': amountDay,
        'wateringPeriod': wateringPeriod,
        'round': round,
        'soakTime': soakTime,
        'frequency': frequency,

      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      hisId = responseData['hisId']; // รับค่า history_id
      isSaved = true;
      notifyListeners();
      print('History saved successfully with ID: $hisId');
    } else {
      throw Exception('Failed to save history');
    }
  }

  Future<void> updateHistory({
    required double amountStart,
    required double amountEnd,
  }) async {
    if (hisId == null || hisId! <= 0) {
      throw Exception('Invalid historyId. Please save history first.');
    }

    final url = Uri.parse('http://210.246.215.73:4000/updatehistory');

    final bodyData = jsonEncode({
      'hisId': hisId,
      'amountStart': amountStart,
      'amountEnd': amountEnd,
    });

    debugPrint("Sending data to update: $bodyData"); // ✅ ตรวจสอบค่าที่ส่งไป

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: bodyData,
    );

    if (response.statusCode == 200) {
      print('Data updated successfully');
    } else {
      print(
          'Update failed with status: ${response.statusCode}, response: ${response.body}');
      throw Exception('Failed to update history');
    }
  }
}
