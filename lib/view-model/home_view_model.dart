import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel with ChangeNotifier {
  List<String> daysName = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الاربعاء',
    'الخميس',
    'الجمعة',
  ];
  List<String> daysNameEnglish = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  int? currentDayIndex;
  set setCurrentDayIndex(int index){
    currentDayIndex = index;
    notifyListeners();
  }

  Map<String, dynamic> subjectsData2 = {};

  Future<void> saveNewSubject2(Map<String,String> subject,String day) async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('subjectsData2');
    if (data != null) {
      subjectsData2 = jsonDecode(data);
    }
    if(subjectsData2.containsKey(day)){
      subjectsData2[day]!.add(subject);
    }else{
      subjectsData2.putIfAbsent(day, () => [subject]);
    }
    await prefs.setString('subjectsData2', jsonEncode(subjectsData2));
    notifyListeners();
  }

  Future<void> getSubjectsData2() async {
    final prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString('subjectsData2');
    if (data != null) {
      subjectsData2 = jsonDecode(data);
    }
    print(subjectsData2);
    notifyListeners();
  }

  Future<void> saveNewSubject(List subject) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('subjectsData', jsonEncode(subject));
    subjectsData = subject;
    notifyListeners();
  }

  List subjectsData = [];

  Future<void> getSubjectsData() async {
    final prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString('subjectsData');
    if (data != null) {
      subjectsData = jsonDecode(data);
    }
    notifyListeners();
  }

  showDateInTimeFormat(DateTime date) {
    return DateFormat("HH:mm a", 'en').format(date).replaceFirst('AM', 'ص').replaceFirst('PM', 'م');
  }
}
