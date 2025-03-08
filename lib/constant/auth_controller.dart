import 'dart:convert';
//import 'package:bean_sprout_test/screens/home.dart';
//import 'package:bean_sprout_test/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/screens/home_screen.dart';

class AuthController {
  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  String? loggedInUserEmail;
  Map<String, dynamic>? userData;

  Future<void> registerUser() async {
    const String url = 'http://210.246.215.73:4000/register';

    final Map<String, String> requestData = {
      'firstname': firstNameEditingController.text,
      'lastname': lastNameEditingController.text,
      'email': emailEditingController.text,
      'password': passwordEditingController.text
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Request was successful
        print('Registration successful');
        print(response.body);
      } else {
        // Request failed
        print('Failed to register');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Error during HTTP request
      print('Error: $error');
    }
  }
  
  // Future<void> loginUser(BuildContext context) async {
  //   const String url = 'http://210.246.215.73:4000/login';

  //   final Map<String, String> requestData = {
  //     'email': emailEditingController.text,
  //     'password': passwordEditingController.text
  //   };

  //   try {
  //     final http.Response response = await http.post(
  //       Uri.parse(url),
  //       headers: <String, String>{'Content-Type': 'application/json'},
  //       body: jsonEncode(requestData),
  //     );

  //     if (response.statusCode == 200) {
  //       loggedInUserEmail = emailEditingController.text;
  //       await fetchUserData(); // Fetch user data after successful login
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomeScreen()),
  //       );
  //       print('Login successful');
  //       print('${loggedInUserEmail}');

  //     } else {
  //       print('Failed to Login: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //   }
  // }

Future<bool> loginUser(BuildContext context) async {
  const String url = 'http://210.246.215.73:4000/login';

  final Map<String, String> requestData = {
    'email': emailEditingController.text,
    'password': passwordEditingController.text
  };

  try {
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      loggedInUserEmail = emailEditingController.text;
      await fetchUserData(); // ดึงข้อมูลผู้ใช้หลังจากเข้าสู่ระบบสำเร็จ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      print('Login successful');
      return true; // ✅ เข้าสู่ระบบสำเร็จ
    } else if (response.statusCode == 401) {
      print('Incorrect password');
      return false; // ❌ รหัสผ่านผิด
    } else {
      print('Login failed: ${response.statusCode}');
      return false;
    }
  } catch (error) {
    print('Error: $error');
    return false;
  }
}


  Future<void> fetchUserData() async {
    if (loggedInUserEmail != null) {
      final response = await http.get(
        Uri.parse('http://210.246.215.73:4000/user?email=$loggedInUserEmail'),
      );
      if (response.statusCode == 200) {
        userData = json.decode(response.body)['data'];
        print('${userData}');

      } else {
        print('Failed to fetch user data: ${response.statusCode}');
      }
    }
  }
}
