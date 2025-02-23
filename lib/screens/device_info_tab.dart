import 'package:flutter/material.dart';
import 'package:mobile/constant/app_state.dart';
import 'package:mobile/constant/info_controller.dart';
import 'package:mobile/constant/manual_controller.dart';
import 'package:mobile/screens/notification.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class DeviceInfoTab extends StatefulWidget {
  @override
  _DeviceInfoTabState createState() => _DeviceInfoTabState();
}

class _DeviceInfoTabState extends State<DeviceInfoTab> {
  //DateTime starttime = DateTime(2023, 11, 29);
  bool isWateringOn = false;
  bool isPumpOn = false;
  bool isManualOn = false;
  final ManualContrller manualContrller = ManualContrller();
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบปลูกถั่วงอก'),
        backgroundColor: const Color.fromARGB(255, 48, 248, 108),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 10, right: 15),
            child: badges.Badge(
              position: badges.BadgePosition.topEnd(top: -1, end: -1),
              showBadge: appState.hasUnreadNotifications,
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(8),
                padding: EdgeInsets.all(6),
                borderSide:
                    BorderSide(color: Colors.white, width: 2), // ขอบสีขาว
              ),
              badgeContent: appState.hasUnreadNotifications
                  ? Text(
                      '${appState.notifications.length}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    )
                  : null,
              child: IconButton(
                icon: Icon(Icons.notifications,
                    size: 28, color: const Color.fromARGB(255, 5, 95, 52)),
                onPressed: () {
                  appState.markNotificationsAsRead();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationSreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => InfoController(),
        child: Consumer<InfoController>(
          builder: (context, infoController, child) {
            if (infoController.isLoading) {
              return Center(child: CircularProgressIndicator()); // แสดงโหลดดิ้ง
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ข้อมูลถังปลูก',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  buildInfoCard(Icons.water_drop, "ความชื้น",
                      "${infoController.humidity?.toStringAsFixed(1) ?? '-'} %"),
                  buildInfoCard(Icons.thermostat, "อุณหภูมิ",
                      "${infoController.temperature?.toStringAsFixed(1) ?? '-'} °C"),
                  /*buildInfoCard(Icons.calendar_today, "วันที่ปลูก",
                      "${starttime.day}/${starttime.month}/${starttime.year}"),*/

                  // เพิ่ม Switch การรดน้ำใต้ความชื้น
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('รดน้ำ:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Switch(
                        value: isWateringOn,
                        onChanged: (value) async {
                          setState(() {
                            isWateringOn = value;
                          });
                          await manualContrller.updatepPumpStatus(
                              value); // ใช้ updatepPumpStatus() สำหรับปุ่มรดน้ำ
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ปล่อยน้ำ:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Switch(
                        value: isPumpOn,
                        onChanged: (value) async {
                          setState(() {
                            isPumpOn = value;
                          });
                          await manualContrller.updateDrainStatus(
                              value); // ใช้ updateDrainStatus() สำหรับปุ่มปล่อยน้ำ
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Manual',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Switch(
                        value: isManualOn,
                        onChanged: (value) async {
                          setState(() {
                            isManualOn = value;
                          });
                          await manualContrller.updateModeStatus(
                              value); // ใช้ updatepPumpStatus() สำหรับปุ่มรดน้ำ
                        },
                      ),
                      SizedBox(width: 8),
                      Text('Auto',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String title, String value) {
    return SizedBox(
      height: 80,
      child: Card(
        elevation: 5,
        child: Row(
          children: [
            Padding(padding: EdgeInsets.all(10), child: Icon(icon, size: 25)),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(value, style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
