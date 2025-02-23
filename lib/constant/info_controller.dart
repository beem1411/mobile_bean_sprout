import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InfoController extends ChangeNotifier {
  double? humidity;
  double? temperature;

  bool isLoading = true;

  InfoController() {
    fetchPlantData();
  }

  Future<void> fetchPlantData() async {
    final url = Uri.parse('http://210.246.215.73:4000/getinfo'); // URL API

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "success") {
          final tankData = data["data"];

          humidity = double.tryParse(tankData["humidity"].toString());
          temperature = double.tryParse(tankData["temperature"].toString());

          isLoading = false;
          notifyListeners();
        } else {
          print("Error: ${data["message"]}");
        }
      } else {
        print("Error fetching data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

