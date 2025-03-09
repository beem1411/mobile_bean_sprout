import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/login.dart';

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

Future<void> logout(BuildContext context) async {
    final userId = userData?['userId'];
    if (userId != null) {
        try {
            final response = await http.post(
                Uri.parse('http://210.246.215.73:4000/logout'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({'userId': userId}),
            );

            if (response.statusCode == 200) {
                print("✅ Logout สำเร็จ");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                );
            } else {
                print("❌ Logout ไม่สำเร็จ: ${response.body}");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ออกจากระบบไม่สำเร็จ กรุณาลองใหม่อีกครั้ง')),
                );
            }
        } catch (e) {
            print("❌ เกิดข้อผิดพลาดระหว่างออกจากระบบ: $e");
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('เครือข่ายมีปัญหา กรุณาตรวจสอบอินเทอร์เน็ต')),
            );
        }
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
