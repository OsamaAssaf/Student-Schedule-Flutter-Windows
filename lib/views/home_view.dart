import 'dart:convert';
import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_schedule/view-model/home_view_model.dart';
import 'package:flutter/material.dart' as material;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _viewModel = HomeViewModel();
  final TextEditingController _subjectController = TextEditingController();
  DateTime? startTime;
  DateTime? endTime;
  String selectedDay = 'اختر يوما';

  @override
  void initState() {
    DateTime date = DateTime.now();
    int currentDayIndex =
        _viewModel.daysNameEnglish.indexWhere((element) => element == DateFormat('EEEE').format(date));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<HomeViewModel>(context, listen: false).setCurrentDayIndex = currentDayIndex;
      await Provider.of<HomeViewModel>(context, listen: false).getSubjectsData2();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (BuildContext context, HomeViewModel provider, _) {
        return NavigationView(
          appBar: NavigationAppBar(
            title: const Text('الجدول'),
            automaticallyImplyLeading: false,
            actions: IconButton(
              icon: const Icon(FluentIcons.settings),
              onPressed: () {},
            ),
          ),
          content: NavigationBody(
            index: 0,
            children: [
              ScaffoldPage(
                bottomBar: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return ContentDialog(
                          title: const Text('إضافة مادة'),
                          content: SingleChildScrollView(
                            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text('اسم المادة'),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      SizedBox(
                                        width: 240.0,
                                        child: TextBox(
                                          controller: _subjectController,
                                          placeholder: 'أدخل اسم المادة الدراسية',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  Row(
                                    children: [
                                      const Text('وقت البداية'),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      OutlinedButton(
                                        child: Text(
                                            startTime != null ? _viewModel.showDateInTimeFormat(startTime!) : '00:00'),
                                        onPressed: () async {
                                          material.TimeOfDay? time = await material.showTimePicker(
                                            context: context,
                                            initialTime: const material.TimeOfDay(hour: 6, minute: 0),
                                          );
                                          if (time != null) {
                                            setState(() {
                                              startTime = DateTime(0, 0, 0, time.hour, time.minute);
                                            });
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        width: 16.0,
                                      ),
                                      const Text('وقت النهاية'),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      OutlinedButton(
                                        child:
                                            Text(endTime != null ? _viewModel.showDateInTimeFormat(endTime!) : '00:00'),
                                        onPressed: () async {
                                          material.TimeOfDay? time = await material.showTimePicker(
                                            context: context,
                                            initialTime: const material.TimeOfDay(hour: 7, minute: 0),
                                          );
                                          if (time != null) {
                                            setState(() {
                                              endTime = DateTime(0, 0, 0, time.hour, time.minute);
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  DropDownButton(
                                    title: Text(selectedDay),
                                    items: _viewModel.daysName.map((day) {
                                      return MenuFlyoutItem(
                                        text: Text(day),
                                        onPressed: () {
                                          setState(() {
                                            selectedDay = day;
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              );
                            }),
                          ),
                          actions: [
                            FilledButton(
                                child: const Text('حفظ'),
                                onPressed: () async {
                                  if (_subjectController.text.isEmpty) {
                                    showSnackbar(
                                      context,
                                      const Snackbar(
                                        content: Text('الرجاء إدخال اسم المادة'),
                                      ),
                                    );
                                    return;
                                  }
                                  if (startTime == null || endTime == null) {
                                    showSnackbar(
                                      context,
                                      const Snackbar(
                                        content: Text('الرجاء إدخال وقت البداية والنهاية'),
                                      ),
                                    );
                                    return;
                                  }
                                  if (selectedDay == 'اختر يوما') {
                                    showSnackbar(
                                      context,
                                      const Snackbar(
                                        content: Text('الرجاء اختيار يوم'),
                                      ),
                                    );
                                    return;
                                  }
                                  Map<String, String> subject = {
                                    'name': _subjectController.text,
                                    'startTime': startTime!.toIso8601String(),
                                    'endTime': endTime!.toIso8601String(),
                                    // 'day': selectedDay
                                  };
                                  await provider.saveNewSubject2(subject, selectedDay);

                                  // await provider.getSubjectsData();
                                  // List dataList = provider.subjectsData;
                                  // dataList.add(subject);
                                  // await provider.saveNewSubject(dataList);
                                }),
                            Button(
                                child: const Text('الغاء'),
                                onPressed: () {
                                  startTime = null;
                                  endTime = null;
                                  _subjectController.clear();
                                  selectedDay = 'اختر يوما';
                                  Navigator.pop(ctx);
                                })
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('أضف مادة'),
                ),
                content: provider.subjectsData2.isNotEmpty
                    ? ListView(
                        children: [
                          for (int i = 0; i < _viewModel.daysName.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Table(
                                children: <TableRow>[
                                  if (provider.subjectsData2.containsKey(_viewModel.daysName[i]))
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.white),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: const Text('من\nإلى'),
                                          ),
                                        ),
                                        for (int j = 0; j < provider.subjectsData2[_viewModel.daysName[i]].length; j++)
                                          TableCell(
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.white),
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    child: Text(_viewModel.showDateInTimeFormat(DateTime.parse(provider
                                                        .subjectsData2[_viewModel.daysName[i]][j]['startTime']))),
                                                    onTap: () {
                                                      showDialog(
                                                        barrierDismissible: true,
                                                        context: context,
                                                        builder: (ctx) {
                                                          return ContentDialog(
                                                            content: TimePicker(
                                                              popupHeight: 500.0,
                                                              amText: 'ص',
                                                              pmText: 'م',
                                                              selected: DateTime(0, 0, 0, 6, 0, 0),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    child: Text(_viewModel.showDateInTimeFormat(DateTime.parse(
                                                        provider.subjectsData2[_viewModel.daysName[i]][j]['endTime']))),
                                                    onTap: () {
                                                      showDialog(
                                                        barrierDismissible: true,
                                                        context: context,
                                                        builder: (ctx) {
                                                          return ContentDialog(
                                                            content: TimePicker(
                                                              popupHeight: 500.0,
                                                              amText: 'ص',
                                                              pmText: 'م',
                                                              selected: DateTime(0, 0, 0, 6, 0, 0),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  if (provider.subjectsData2.containsKey(_viewModel.daysName[i]))
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.white),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              _viewModel.daysName[i],
                                              style: TextStyle(
                                                  color: provider.currentDayIndex == i ? Colors.green : Colors.white),
                                            ),
                                          ),
                                        ),
                                        if (provider.subjectsData2.containsKey(_viewModel.daysName[i]))
                                          for (int j = 0;
                                              j < provider.subjectsData2[_viewModel.daysName[i]].length;
                                              j++)
                                            TableCell(
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.white),
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        provider.subjectsData2[_viewModel.daysName[i]][j]['name'],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/table.png',
                              width: 180.0,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            const Text(
                              'لم تقم بإضافة أي مواد بعد',
                              style: TextStyle(
                                fontSize: 32.0,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
