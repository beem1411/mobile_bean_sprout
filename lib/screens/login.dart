import 'package:flutter/material.dart';
import 'package:mobile/constant/auth_controller.dart';
import 'package:mobile/screens/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// form key
final _formkey = GlobalKey();
// editing controller
final authController = AuthController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // email field
    final emailField = TextFormField(
        autofocus: false,
        controller: authController.emailEditingController,
        keyboardType: TextInputType.emailAddress,
        // validator: (value) {} ,
        onSaved: (value) {
          authController.emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail), //l/t/r/bt
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "อีเมล",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    // password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: authController.passwordEditingController,
        obscureText: true,
        // validator: (value) {} ,
        onSaved: (value) {
          authController.passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key), //l/t/r/bt
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "รหัสผ่าน",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromARGB(255, 108, 253, 132),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        /*onPressed: () { 
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },*/
        onPressed: () {
          authController.loginUser(context);
        },
        child: Text(
          "เข้าสู่ระบบ",
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
                        height: 200,
                        child: Image.asset(
                          "assets/logo.jpg",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 45),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 15),
                    loginButton,
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("ยังไม่ได้ลงทะเบียนใช่ไหม ?",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                          },
                          child: Text(
                            " ลงทะเบียน",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        )
                      ],
                    ),
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
