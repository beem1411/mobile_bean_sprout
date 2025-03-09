import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:mobile/constant/app_state.dart';
import 'package:mobile/constant/history_controller.dart';
import 'package:mobile/screens/notification.dart';
import 'package:mobile/widgets/circular_percent.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class StepsTab extends StatefulWidget {
  const StepsTab({super.key});

  @override
  State<StepsTab> createState() => _StepsTabState();
}

class _StepsTabState extends State<StepsTab> {
  final HistoryController controller = HistoryController();
  final TextEditingController amountstartController = TextEditingController();
  final TextEditingController amountendController = TextEditingController();
  int currentStep = 0;
  final int totalSteps = 4;
  Timer? _timer;
  Duration _stRemaining = Duration(seconds: 0);
  Duration _timeRemaining = Duration(seconds: 0);
  List<Map<String, dynamic>> history = [];
  int round = 0;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.soakingTimeRemaining.inSeconds == 0) {
      appState.updateSoakingTime(appState.soakTime);
    }
    appState.startSoakingTimer();
    amountstartController.text = appState.savedAmountStart?.toString() ?? '';
    amountendController.text = appState.savedAmountEnd?.toString() ?? '';
  }

  String formatTime24(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void calculateAndSetAmountEnd() {
    final appState = Provider.of<AppState>(context, listen: false);
    final amountStart = double.tryParse(amountstartController.text) ?? 0.0;
    final amountEnd = amountStart * 10.0;
    amountendController.text = amountEnd.toStringAsFixed(2);
    appState.updateAmountStart(amountStart);
    appState.updateAmountEnd(amountEnd);
  }

  void nextStep() {
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.currentStep < totalSteps - 1) {
      appState.updateCurrentStep(appState.currentStep + 1);
    }
    if (appState.currentStep == 2 || appState.currentStep == 3) {
      startTimer(context);
    }
  }

  void previousStep() {
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.currentStep > 0) {
      appState.updateCurrentStep(appState.currentStep - 1);
    }
  }

  void soakingTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_stRemaining.inSeconds > 0) {
        setState(() {
          _stRemaining = _stRemaining - Duration(seconds: 1);
          //print('${_stRemaining}');
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void startTimer(BuildContext context) {
  final appState = Provider.of<AppState>(context, listen: false);
  final difference = appState.endDate!.difference(DateTime.now());

  if (difference.inSeconds > 0) {
    if (!mounted) return; 
    setState(() {
      _timeRemaining = difference;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel(); 
        return;
      }

      setState(() {
        if (_timeRemaining.inSeconds > 0) {
          _timeRemaining = _timeRemaining - Duration(seconds: 1);
        } else {
          _timer?.cancel();
        }
      });
    });
  } else {
    if (!mounted) return;
    setState(() {
      _timeRemaining = Duration.zero;
    });
  }
}

  bool get isTimerComplete => _timeRemaining.inSeconds == 0;

  String _calculateRemainingTime(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final now = DateTime.now();
    if (appState.startDate == null || appState.endDate == null) {
      return 'Not available';
    }

    final endTimeDate = DateTime(
      appState.endDate!.year,
      appState.endDate!.month,
      appState.endDate!.day,
      appState.endTime.hour,
      appState.endTime.minute,
    );

    if (endTimeDate.isBefore(now)) {
      return 'Time completed';
    }

    final difference = endTimeDate.difference(now);

    return '${difference.inDays} วัน ${difference.inHours.remainder(24).toString().padLeft(2, '0')}:${difference.inMinutes.remainder(60).toString().padLeft(2, '0')}:${difference.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyController = Provider.of<HistoryController>(context);
    final appState = Provider.of<AppState>(context);
    int currentStep = appState.currentStep;
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
                borderSide: BorderSide(color: Colors.white, width: 2),
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
      body: Center(
        child: // หน้า "ขั้นตอน"
            Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 10.0,
                  percent: (currentStep + 1) / totalSteps,
                  center: Text(
                    "${((currentStep + 1) / totalSteps * 100).toInt()} %",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  progressColor: Colors.green,
                ),
                const SizedBox(height: 20),
                Text(
                  "ขั้นตอน ${currentStep + 1}: ${steps[currentStep]['title']}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    totalSteps,
                    (index) => CircleAvatar(
                      backgroundColor:
                          index == currentStep ? Colors.green : Colors.grey,
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  steps[currentStep]['description']!,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // แสดง TextField เฉพาะในขั้นตอนที่ 1
                if (currentStep == 0)
                  Column(
                    children: [
                      TextField(
                        controller: amountstartController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'จำนวนถั่วงอก(กิโลกรัม)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          final appState =
                              Provider.of<AppState>(context, listen: false);
                          appState
                              .updateAmountStart(double.tryParse(value) ?? 0.0);
                          calculateAndSetAmountEnd();
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                if (currentStep == 1)
                  Column(
                    children: [
                      Text(
                        "เวลาที่เหลือ: ${appState.soakingTimeRemaining.inHours.toString().padLeft(2, '0')}:${appState.soakingTimeRemaining.inMinutes.remainder(60).toString().padLeft(2, '0')}:${appState.soakingTimeRemaining.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                // แสดงเวลาเหลือในขั้นตอนที่ 3
                if (currentStep == 2)
                  Column(
                    children: [
                      Text(
                        "เวลาที่เหลือ : ${_calculateRemainingTime(context)}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                // แสดงจำนวนถั่วงอกที่คูณ 10 ในขั้นตอนที่ 4
                if (currentStep == 3)
                  Column(
                    children: [
                      Text(
                        //"จำนวนถั่วงอกที่ได้โดยประมาณ : ${int.tryParse(amountstartController.text) != null ? int.parse(amountstartController.text) * 10 : 0}",
                        "จำนวนถั่วงอกที่ได้โดยประมาณ :  ${(appState.savedAmountStart ?? 0) * 10} กิโลกรัม",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ElevatedButton(
                  onPressed: () {
                    //nextStep();
                    if (currentStep == 0) {
                      final beanSproutCount = amountstartController.text;
                      if (beanSproutCount.isNotEmpty) {
                        String startDate =
                            DateFormat('d/M/yy').format(appState.startDate!);
                        String endDate =
                            DateFormat('d/M/yy').format(appState.endDate!);

                        String title = 'ถั่วงอกรอบวันที่ $startDate - $endDate';
                        String message = 'เริ่มแช่เมล็ดถั่วเขียวในถังปลูก';

                        // ✅ แจ้งเตือนผ่าน NotificationService
                        // NotificationService.showNotification(
                        //   title: title,
                        //   body: message,
                        // );

                        // ✅ เพิ่มแจ้งเตือนเข้า ListView
                        appState.addNotification(title, message);
                        Map<String, dynamic> newRecord = {
                          'round': appState.round,
                          'date': DateFormat('d/M/yy').format(
                              appState.startDate!), //appState.startDate,
                          'status': 'เริ่มปลูก',
                          'amountStart':
                              int.tryParse(amountstartController.text) ?? 0,
                        };
                        appState.startPlanting(newRecord);
                        calculateAndSetAmountEnd();
                        nextStep();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('กรุณาใส่จำนวนถั่วงอก')),
                        );
                      }
                    } else if (currentStep == 1) {
                      nextStep();
                      // ในขั้นตอนที่ 2 จะไม่สามารถกดถัดไปได้จนกว่าจะครบ
                      if (isTimerComplete) {
                        nextStep();
                      } else {
                        print('กรุณารอจนกว่าเวลาจะหมด');
                      }
                    } else if (currentStep == 3) {
                      if (amountstartController.text.isEmpty ||
                          amountendController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
                        );
                        return;
                      }
                      if (historyController.isSaved) {
                        historyController.updateHistory(
                          amountStart:
                              double.tryParse(amountstartController.text) ??
                                  0.0,
                          amountEnd:
                              double.tryParse(amountendController.text) ?? 0.0,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('บันทึกสำเร็จ!')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('โปรดบันทึกประวัติการปลูกก่อน')));
                      }
                      Map<String, dynamic> endRecord = {
                        'round': appState.round,
                        'date': DateFormat('d/M/yy')
                            .format(appState.endDate!), //appState.endDate,
                        'status': 'เก็บแล้ว',
                      };

                      appState.endPlanting(endRecord);
                      print(
                          'เก็บแล้ว: รอบ ${appState.round}, วันที่ ${appState.endDate}');
                      print('📌 ประวัติการปลูกอัปเดต: $history');

                      print("Start Date: ${appState.startDate!}");
                      print("End Date: ${appState.endDate!}");
                      //print("Start Time: ${widget.starttime.format(context)}");
                      // print("End Time: ${widget.endtime.format(context)}");
                      print("Start Time: ${formatTime24(appState.startTime)}");
                      print("End Time: ${formatTime24(appState.endTime)}");
                      print("Amount Day: ${appState.amountDay}");
                      print("Watering Period: ${appState.wateringPeriod}");
                      print("Round: ${appState.round}");
                      print(
                          "Amount Start: ${int.tryParse(amountstartController.text) ?? 0}");
                      print(
                          "Amount End: ${int.tryParse(amountendController.text) ?? 0}");
                      //
                      print("Soak Time: ${_stRemaining.inHours}");

                      print(
                          "Soak Time Before Saving (Final Check): ${_stRemaining.inHours}");

                      int nextRound = appState.round + 1;
                      appState.updateSchedule(
                        newStartDate: appState.startDate,
                        newEndDate: appState.endDate,
                        newStartTime: appState.startTime,
                        newEndTime: appState.endTime,
                        newAmountDay: appState.amountDay,
                        newWateringPeriod: appState.wateringPeriod,
                        newRound: nextRound,
                        newSoakTime: appState.soakTime,
                        newFrequency: appState.frequeency,
                      );

                      appState.clearAmountStart();
                      //amountstartController.clear();
                      appState.updateCurrentStep(0);
                      Navigator.pop(context);
                    } else {
                      nextStep();
                    } //
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    currentStep == 0
                        ? 'เริ่ม'
                        : currentStep == 3
                            ? 'สิ้นสุด'
                            : 'ถัดไป',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<Map<String, String>> steps = [
    {
      'title': 'เตรียมเมล็ดถั่ว',
      'description': 'ล้างและแช่เมล็ดถั่วในน้ำสะอาดเป็นเวลา 6-8 ชั่วโมง',
    },
    {
      'title': 'เริ่มปลูก',
      'description': 'แช่เมล็ดถั่วเขียวในถังปลูก',
    },
    {
      'title': 'กำลังปลูก',
      'description': 'รดน้ำถั่วงอกตามเงื่อนไข',
    },
    {
      'title': 'เก็บเกี่ยว',
      'description': 'เก็บถั่วงอก.',
    },
  ];
}
