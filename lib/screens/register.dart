import 'package:flutter/material.dart';
import 'package:mobile/constant/auth_controller.dart';

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
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key), //l/t/r/bt
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "รหัสผ่าน",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    // confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: authController.confirmPasswordEditingController,
        obscureText: true,
        // validator: (value) {} ,
        onSaved: (value) {
          authController.confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key), //l/t/r/bt
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
          authController.registerUser();
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
