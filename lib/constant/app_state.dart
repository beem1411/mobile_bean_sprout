import 'dart:async';

import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay startTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 15, minute: 0);
  int amountDay = 0;
  int wateringPeriod = 0;
  int round = 1;
  List<Map<String, dynamic>> history = [];
  int currentStep = 0;
  int soakTime = 0;
  int frequeency = 0 ;
  Duration _stRemaining = Duration(seconds: 0);
  Timer? _timer;
  // int? savedAmountStart;
  // int? savedAmountEnd;

  double? savedAmountStart;
  double? savedAmountEnd;

  // Duration _stRemaining = Duration(seconds: 0);
  // bool _timerRunning = false;
  // Timer? _timer;

  // Duration get soakingTimeRemaining => _stRemaining;

  //   void updateSoakingTime(int hours) {
  //   _stRemaining = Duration(hours: hours);
  //   notifyListeners();
  // }

  //   void startSoakingTimer() {
  //   if (!_timerRunning) {
  //     _timerRunning = true;
  //     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //       if (_stRemaining.inSeconds > 0) {
  //         _stRemaining -= Duration(seconds: 1);
  //         notifyListeners();
  //       } else {
  //         _timer?.cancel();
  //         _timerRunning = false;
  //       }
  //     });
  //   }
  // }

  Duration get soakingTimeRemaining => _stRemaining;

  // void updateSoakingTime(int hours) {
  //   _stRemaining = Duration(hours: hours);
  //   notifyListeners();
  // }

  void updateSoakingTime(int hours) {
    _stRemaining = Duration(hours: hours);

    // Delay notifyListeners to avoid calling it during the build phase
    Future.microtask(() {
      notifyListeners();
    });
  }

  void startSoakingTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_stRemaining.inSeconds > 0) {
          _stRemaining -= Duration(seconds: 1);
          notifyListeners();
        } else {
          _timer?.cancel();
        }
      });
    }
  }

  void updateCurrentStep(int step) {
    currentStep = step;
    notifyListeners();
  }

  void updateSchedule(
      {required DateTime? newStartDate,
      required DateTime? newEndDate,
      required TimeOfDay newStartTime,
      required TimeOfDay newEndTime,
      required int newAmountDay,
      required int newWateringPeriod,
      required int newRound,
      required int newSoakTime,
      required int newFrequency}) {
    startDate = newStartDate;
    endDate = newEndDate;
    startTime = newStartTime;
    endTime = newEndTime;
    amountDay = newAmountDay;
    wateringPeriod = newWateringPeriod;
    round = newRound;
    soakTime = newSoakTime;
    newFrequency= newFrequency;

    if (newRound > round) {
      currentStep = 0;
    }

    notifyListeners();
  }

  void clearAmountStart() {
    savedAmountStart = null;
    notifyListeners();
  }

  void startPlanting(Map<String, dynamic> record) {
    history.add(record);
    notifyListeners();
  }

  void endPlanting(Map<String, dynamic> record) {
    history.add(record);
    notifyListeners();
  }

  void updateAmountStart(double amount) {
    savedAmountStart = amount;
    notifyListeners();
  }

  void updateAmountEnd(double amount) {
    savedAmountEnd = amount;
    notifyListeners();
  }


  final List<Map<String, String>> _notifications = [];
  bool _hasUnreadNotifications = false;

  List<Map<String, String>> get notifications => _notifications;
  bool get hasUnreadNotifications => _hasUnreadNotifications;

void addNotification(String title, String subtitle) {
  _notifications.insert(0, {'title': title, 'subtitle': subtitle});
  _hasUnreadNotifications = true;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    notifyListeners();
  });
}

  void markNotificationsAsRead() {
    _hasUnreadNotifications = false;
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    _hasUnreadNotifications = false;
    notifyListeners();
  }
}
