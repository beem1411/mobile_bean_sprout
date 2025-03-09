import 'package:flutter/material.dart';
import 'package:mobile/constant/app_state.dart';
import 'package:mobile/constant/auth_controller.dart';
import 'package:mobile/constant/connection_controller.dart';
import 'package:mobile/constant/history_controller.dart';
import 'package:mobile/constant/settings_controller.dart';
import 'package:mobile/screens/notification.dart';
import 'package:mobile/screens/step_tab.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class ScheduleTab extends StatefulWidget {
  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  final HistoryController controller = HistoryController();
  final SettingsController setcontroller = SettingsController();
  final AuthController authController = AuthController();
  final ConnectionController cntController = ConnectionController();

  int? userId;
  String? tankId;

  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay startTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 15, minute: 0);
  int amountDay = 0;
  int wateringPeriod = 0;
  int soakTime = 0;
  int frequency = 0;

  //int round = 1;

  @override
  void initState() {
    super.initState();
    _defaultSettings();

  }



  void _defaultSettings() async {
    await setcontroller.fetchDefaultSettings();
    setState(() {
      if (setcontroller.startTime != null) startTime = setcontroller.startTime!;
      if (setcontroller.endTime != null) endTime = setcontroller.endTime!;
      amountDay = setcontroller.amountDay;
      wateringPeriod = setcontroller.wateringPeriod;
      soakTime = setcontroller.soakTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final historyController = Provider.of<HistoryController>(context);
    int round = Provider.of<AppState>(context).round;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'กำหนดเวลาในการปลูกถั่วงอก',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('รอบปลูกที่ : $round', style: TextStyle(fontSize: 20)),
              SizedBox(height: 15),
              buildDurationInput(),
              SizedBox(height: 10),
              buildDatePicker('วันที่เริ่มปลูก', startDate, _selectStartDate),
              SizedBox(height: 10),
              Text('วันเก็บถั่วงอก : ${formatDate(endDate)}',
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              buildTimePicker('เวลาที่เริ่มรดน้ำ', startTime, _selectStartTime),
              SizedBox(height: 10),
              buildTimePicker('เวลาสิ้นสุดการรดน้ำ', endTime, _selectEndTime),
              SizedBox(height: 10),
              buildWateringPeriodInput(),
              SizedBox(height: 20),
              buildSoakTimeInput(),
              SizedBox(height: 20),
              buildFrequencyInput(),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (startDate != null && endDate != null) {
                      try {
                        await historyController.saveHistory(
                          startDate: startDate!,
                          endDate: endDate!,
                          startTime: formatTime(startTime),
                          endTime: formatTime(endTime),
                          amountDay: amountDay,
                          wateringPeriod: wateringPeriod,
                          round: round,
                          soakTime: soakTime,
                          frequency: frequency,
                        );
                        // 🔹 บันทึกข้อมูลลง Provider
                        appState.updateSchedule(
                          newStartDate: startDate,
                          newEndDate: endDate,
                          newStartTime: startTime,
                          newEndTime: endTime,
                          newAmountDay: amountDay,
                          newWateringPeriod: wateringPeriod,
                          newRound: round,
                          newSoakTime: soakTime,
                          newFrequency: frequency,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StepsTab()));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
                      );
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('บันทึกข้อมูล',
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDurationInput() {
    return Row(
      children: [
        Text('ระยะเวลาปลูก (วัน): $amountDay', style: TextStyle(fontSize: 20)),
        SizedBox(width: 16),
        buildIconButton(Icons.edit, _editDuration),
      ],
    );
  }

  Widget buildDatePicker(
      String label, DateTime? date, Function(BuildContext) onSelect) {
    return Row(
      children: [
        Text('$label : ${formatDate(date)}', style: TextStyle(fontSize: 20)),
        SizedBox(width: 16),
        buildIconButton(Icons.calendar_today, () => onSelect(context)),
      ],
    );
  }

  Widget buildWateringPeriodInput() {
    return Row(
      children: [
        Text('ระยะเวลาที่รดน้ำ : $wateringPeriod นาทีต่อรอบ',
            style: TextStyle(fontSize: 20)),
        SizedBox(width: 16),
        buildIconButton(Icons.edit, _editWateringPeriod),
      ],
    );
  }

  Widget buildSoakTimeInput() {
    return Row(
      children: [
        Text('เวลาแช่ถั่วงอกในถังปลูก : $soakTime ชม.',
            style: TextStyle(fontSize: 20)),
        SizedBox(width: 16),
        buildIconButton(Icons.edit, _editSoakTime),
      ],
    );
  }

  Widget buildFrequencyInput() {
    return Row(
      children: [
        Text('ระยะห่างในการรดน้ำ : $frequency ชม.',
            style: TextStyle(fontSize: 20)),
        SizedBox(width: 16),
        buildIconButton(Icons.edit, _editFrequency),
      ],
    );
  }

  Widget buildIconButton(IconData icon, VoidCallback onPressed) {
    return Ink(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 3, 244, 180),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: IconButton(icon: Icon(icon), onPressed: onPressed),
    );
  }

  Widget buildTimePicker(
      String label, TimeOfDay time, Function(BuildContext) onSelect) {
    return Row(
      children: [
        Text('$label : ${formatTime(time)}', style: TextStyle(fontSize: 20)),
        SizedBox(width: 16),
        buildIconButton(Icons.access_time, () => onSelect(context)),
      ],
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        startDate = selectedDate;
        _calculateEndDate();
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (selectedTime != null) {
      setState(() {
        startTime = selectedTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (selectedTime != null) {
      setState(() {
        endTime = selectedTime;
      });
    }
  }

  void _calculateEndDate() {
    if (startDate != null && amountDay > 0) {
      setState(() {
        endDate = startDate!.add(Duration(days: amountDay));
      });
    }
  }

  Future<void> _editDuration() async {
    int? duration = await _showInputDialog(
        'กำหนดระยะเวลาปลูก', 'ระยะเวลา (วัน)', amountDay);
    if (duration != null) {
      setState(() {
        amountDay = duration;
        _calculateEndDate();
      });
    }
  }

  Future<void> _editWateringPeriod() async {
    int? period = await _showInputDialog(
        'กำหนดเวลารดน้ำแต่ละรอบ', 'ระยะเวลา (นาที)', wateringPeriod);
    if (period != null) {
      setState(() {
        wateringPeriod = period;
      });
    }
  }

  Future<void> _editSoakTime() async {
    int? soak = await _showInputDialog(
        'กำหนดเวลาแช่ถั่วงอก', 'ระยะเวลา (ชั่วโมง)', soakTime);
    if (soak != null) {
      setState(() {
        soakTime = soak;
      });
    }
  }

  Future<void> _editFrequency() async {
    int? fquency = await _showInputDialog(
        'กำหนดระยะห่างในการรดน้ำ', 'ระยะเวลา (ชั่วโมง)', frequency);
    if (fquency != null) {
      setState(() {
        frequency = fquency;
      });
    }
  }

  Future<int?> _showInputDialog(
      String title, String label, int initialValue) async {
    TextEditingController controller =
        TextEditingController(text: initialValue.toString());
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(fontSize: 20)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, int.tryParse(controller.text)),
            child: Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  String formatTime(TimeOfDay time) {
    final int hour = time.hour;
    final int minute = time.minute;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Not selected';
    return '${date.day}/${date.month}/${date.year}';
  }
}
