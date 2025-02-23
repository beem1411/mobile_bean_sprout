import 'package:flutter/material.dart';
import 'package:mobile/screens/device_details_screen.dart';
//import '../screens/detail.dart';

class DeviceTile extends StatelessWidget {
  final String deviceName;

  DeviceTile({required this.deviceName});

  // void getsetting() async {
  //   print("get");
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print('${deviceName}');
        //  getsetting();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeviceDetailsScreen(deviceName: deviceName),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 48, color: Color.fromARGB(255, 55, 189, 77)),
            SizedBox(height: 8),
            Text(deviceName, style: TextStyle(fontSize: 18)), // ชื่ออุปกรณ์
          ],
        ),
      ),
    );
  }
}
