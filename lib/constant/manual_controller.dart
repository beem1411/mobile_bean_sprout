import 'package:http/http.dart' as http;
import 'dart:convert';

class ManualContrller {
  Future<void> updatepPumpStatus(bool isWatering) async {
    final url = Uri.parse('http://210.246.215.73:4000/pump/fill');

    final data = {
      "tankId": 1,
      "action": isWatering ? "ON" : "OFF",
    };

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Tank status updated successfully");
      } else {
        print("Failed to update tank: ${response.body}");
      }
    } catch (e) {
      print("Error updating tank: $e");
    }
  }

  Future<void> updateDrainStatus(bool isDraining) async {
    final url = Uri.parse('http://210.246.215.73:4000/pump/drain');

    final data = {
      "tankId": 1,
      "action": isDraining ? "ON" : "OFF",
    };

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Drain status updated successfully");
      } else {
        print("Failed to update drain status: ${response.body}");
      }
    } catch (e) {
      print("Error updating drain status: $e");
    }
  }

  Future<void> updateModeStatus(bool isManual) async {
    final url = Uri.parse('http://210.246.215.73:4000/change/mode');

    final data = {
      "tankId": 1,
      "mode": isManual ? "AUTO" : "MANUAL",
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Mode status updated successfully");
      } else {
        print("Failed to update mode status: ${response.body}");
      }
    } catch (e) {
      print("Error updating mode status: $e");
    }
  }
}
