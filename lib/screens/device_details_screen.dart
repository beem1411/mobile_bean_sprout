import 'package:flutter/material.dart';
import 'package:mobile/screens/step_tab.dart';
import 'device_info_tab.dart';
import 'schedule_tab.dart';
//import 'notification.dart';

class DeviceDetailsScreen extends StatefulWidget {
  final String deviceName;

  DeviceDetailsScreen({required this.deviceName});

  @override
  _DeviceDetailsScreenState createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  int currentPageIndex = 0;

  // เก็บค่าที่ต้องการแชร์
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay startTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 15, minute: 0);
  int amountDay = 0;
  int round = 1;
  int wateringPeriod = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          DeviceInfoTab(), // แถบเมนู "ข้อมูล"
          ScheduleTab(),
          StepsTab(), // แถบเมนู "ขั้นตอน"
        ],
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Color.fromARGB(255, 108, 253, 132),
        selectedIndex: currentPageIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.info), label: 'ข้อมูล'),
          NavigationDestination(icon: Icon(Icons.schedule), label: 'ตั้งเวลา'),
          NavigationDestination(
              icon: Icon(Icons.format_list_numbered), label: 'ขั้นตอน'),
        ],
      ),
    );
  }
}
