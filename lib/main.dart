// 

import 'package:flutter/material.dart';
import 'package:mobile/constant/app_state.dart';
import 'package:mobile/constant/history_controller.dart';
import 'package:mobile/constant/info_controller.dart';
import 'package:mobile/constant/settings_controller.dart';
import 'package:mobile/screens/login.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => HistoryController()),
        ChangeNotifierProvider(create: (context) => SettingsController()),
        ChangeNotifierProvider(create: (context) => InfoController()),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
    );
  }
}

