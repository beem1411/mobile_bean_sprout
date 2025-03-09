import 'package:flutter/material.dart';
import 'package:mobile/constant/connection_controller.dart';

class AddDevicePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final ConnectionController cntController = ConnectionController();
  final int userId; // รับค่า userId จากหน้า Login
  AddDevicePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มอุปกรณ์'),
        backgroundColor: Color.fromARGB(255, 48, 248, 108),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'ID ถังปลูก',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  cntController.addDeviceToServer(
                    _controller.text, // tankId
                    userId, // userId
                  );
                  Navigator.pop(context, _controller.text); // ส่งค่ากลับ
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('กรุณากรอกหมายเลขอุปกรณ์')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 126, 255, 165)),
              child: Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}
