import 'package:flutter/material.dart';
import 'package:mobile/constant/auth_controller.dart';
import 'package:mobile/screens/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // our form key
  final _formkey = GlobalKey<FormState>();
  //editing Controller
  final authController = AuthController();

  @override
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
        autofocus: false,
        controller: authController.firstNameEditingController,
        keyboardType: TextInputType.name,
        // validator: (value) {} ,
        onSaved: (value) {
          authController.firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle), //l/t/r/bt
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "ชื่อ",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    // last name field
    final lastNameField = TextFormField(
        autofocus: false,
        controller: authController.lastNameEditingController,
        keyboardType: TextInputType.name,
        // validator: (value) {} ,
        onSaved: (value) {
          authController.lastNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle), //l/t/r/bt
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "นามสกุล",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    // email field
    final emailField = TextFormField(
        autofocus: false,
        controller: authController.emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "กรุณากรอกอีเมล";
          } else if (!value.contains("@")) {
            return "รูปแบบอีเมลไม่ถูกต้อง";
          }
          return null;
        },
        onSaved: (value) {
          authController.emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "อีเมล",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final passwordField = TextFormField(
        autofocus: false,
        controller: authController.passwordEditingController,
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "กรุณากรอกรหัสผ่าน";
          } else if (value.length < 8) {
            return "รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร";
          }
          return null;
        },
        onSaved: (value) {
          authController.passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "รหัสผ่าน",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: authController.confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "กรุณายืนยันรหัสผ่าน";
          } else if (value.length < 8) {
            return "รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร";
          } else if (value != authController.passwordEditingController.text) {
            return "รหัสผ่านไม่ตรงกัน";
          }
          return null;
        },
        onSaved: (value) {
          authController.confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "ยืนยันรหัสผ่าน",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

final signUpButton = Material(
  elevation: 5,
  borderRadius: BorderRadius.circular(30),
  color: Color.fromARGB(255, 108, 253, 132),
  child: MaterialButton(
    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    minWidth: MediaQuery.of(context).size.width,
    onPressed: () {
      if (_formkey.currentState!.validate()) {
        authController.registerUser().then((_) {
          // กลับไปที่หน้า LoginScreen หลังจากลงทะเบียนสำเร็จ
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }).catchError((error) {
          // กรณีลงทะเบียนไม่สำเร็จ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("ลงทะเบียนไม่สำเร็จ: $error")),
          );
        });
      }
    },
    child: Text(
      "ลงทะเบียน",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 10, 0, 0),
          fontWeight: FontWeight.bold),
    ),
  ),
);


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        //height: 200,
                        child: Text(
                      'ลงทะเบียน',
                      style: TextStyle(fontSize: 45),
                    )),
                    SizedBox(height: 40),
                    firstNameField,
                    SizedBox(height: 20),
                    lastNameField,
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 20),
                    confirmPasswordField,
                    SizedBox(height: 20),
                    signUpButton,
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
