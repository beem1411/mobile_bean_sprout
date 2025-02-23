import 'package:flutter/material.dart';
import 'add_device_page.dart';
import '../widgets/device_tile.dart';
import '../widgets/add_device_button.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Widget> devices = [];

  @override
  void initState() {
    super.initState();
    devices = [AddDeviceButton(onTap: navigateToAddPage)];
  }

  void navigateToAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDevicePage()),
    );

    if (result != null && result is String && result.isNotEmpty) {
      setState(() {
        devices.insert(devices.length - 1, DeviceTile(deviceName: result));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/ถั่วงอก1.jpg'),
        SizedBox(height: 10),
        Text(
          'อุปกรณ์ที่เชื่อมทั้งหมด',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            padding: EdgeInsets.all(10),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return devices[index];
            },
          ),
        ),
      ],
    );
  }
}
