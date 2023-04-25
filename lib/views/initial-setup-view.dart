import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_schedule/model/subject_model.dart';
import 'package:student_schedule/view-model/initial-setup-view-model.dart';

class InitialSetupView extends StatelessWidget {
  InitialSetupView({Key? key}) : super(key: key);

  final InitialSetupViewModel _viewModel = InitialSetupViewModel();
  final TextEditingController _subjectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<InitialSetupViewModel>(
      builder: (BuildContext context, InitialSetupViewModel provider, _) {
        return NavigationView(
          appBar: const NavigationAppBar(
            title: Text('إعدادات أولية'),
            automaticallyImplyLeading: false,
          ),
          pane: NavigationPane(
            selected: provider.currentIndex,
            displayMode: PaneDisplayMode.auto,
            items: [
              PaneItem(
                icon: const Icon(FluentIcons.number_symbol),
                title: const Text('تحديد عدد المواد'),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.calendar_day),
                title: const Text('تحديد الأيام'),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.add),
                title: const Text('إضافة مواد'),
              ),
            ],
          ),
          content: NavigationBody(
            index: provider.currentIndex,
            children: [
              ScaffoldPage(
                header: const PageHeader(
                  title: Text('تحديد عدد المواد'),
                ),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NavigationBody(
                    index: 0,
                    children: [
                      ScaffoldPage(
                        header: const PageHeader(
                          title: Text('الرجاء تحديد العدد الأقصى للحصص أو المواد اليومية'),
                        ),
                        content: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                itemCount: 10,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: RadioButton(
                                        checked: provider.radioIndex == index + 1,
                                        onChanged: (value) {
                                          provider.setRadioIndex = index + 1;
                                          provider.setLecturesCount = index + 1;
                                        },
                                        content: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text('${index + 1} حصة / مادة'),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, int index) {
                                  return const Divider();
                                },
                              ),
                              if (provider.lecturesCount != 0)
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: FilledButton(
                                      child: const Text('التالي'),
                                      onPressed: () {
                                        provider.setCurrentIndex = 1;
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ScaffoldPage(
                header: const PageHeader(
                  title: Text('تحديد الأيام'),
                ),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NavigationBody(
                    index: 0,
                    children: [
                      ScaffoldPage(
                        header: const PageHeader(
                          title: Text('الرجاء تحديد ايام الدوام وأيام العطل'),
                        ),
                        content: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                itemCount: _viewModel.weekDays.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Checkbox(
                                        checked: provider.weekDays[index]['isChecked'],
                                        onChanged: (bool? value) {
                                          provider.setWeekDayCheckedValue(index, value!);
                                        },
                                        content: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(_viewModel.weekDays[index]['name']),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, int index) {
                                  return const Divider();
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: FilledButton(
                                        child: const Text('التالي'),
                                        onPressed: () {
                                          if (provider.getCheckedDays().isEmpty) {
                                            showSnackbar(
                                              context,
                                              const Snackbar(
                                                content: Text('عليك اختيار يوم واحد على الأقل'),
                                              ),
                                            );
                                            return;
                                          }
                                          provider.setCurrentIndex = 2;
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: FilledButton(
                                        child: const Text('السابق'),
                                        onPressed: () {
                                          provider.setCurrentIndex = 0;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ScaffoldPage(
                header: const PageHeader(
                  title: Text('إضافة مواد'),
                ),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NavigationBody(
                    index: 0,
                    children: [
                      ScaffoldPage(
                        header: PageHeader(
                          title: const Text('الرجاء إضافة المواد التي تدرسها'),
                          commandBar: SizedBox(
                            width: 48.0,
                            height: 48.0,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: FilledButton(
                                style: ButtonStyle(
                                  shape: ButtonState.all(const CircleBorder()),
                                ),
                                child: const Icon(
                                  FluentIcons.add,
                                  size: 18.0,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (cnt) {
                                      return ContentDialog(
                                        title: const Text('إضافة مادة دراسية'),
                                        content: SingleChildScrollView(
                                          child: Column(
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
                                                  const Text('اسم المادة'),
                                                  const SizedBox(
                                                    width: 8.0,
                                                  ),
                                                  StatefulBuilder(
                                                      builder: (BuildContext context, StateSetter setState) {
                                                    return FilledButton(
                                                      style: ButtonStyle(
                                                        backgroundColor: ButtonState.all<Color>(provider.currentColor),
                                                      ),
                                                      child: const Text('اضغط لاختيار لون'),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (ctx) {
                                                            return ContentDialog(
                                                              constraints: const BoxConstraints(
                                                                maxWidth: double.infinity,
                                                              ),
                                                              title: const Text('اختر لون'),
                                                              content: SingleChildScrollView(
                                                                child: material.Material(
                                                                  child: ColorPicker(
                                                                    pickerColor: _viewModel.pickerColor,
                                                                    onColorChanged: (Color color) {
                                                                      _viewModel.pickerColor = color;
                                                                      // Provider.of<InitialSetupViewModel>(context,listen: false).setPickerColor = color;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                FilledButton(
                                                                  child: const Text('حفظ'),
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      provider.currentColor = _viewModel.pickerColor;
                                                                    });
                                                                    provider.setCurrentColor = _viewModel.pickerColor;
                                                                    Navigator.of(ctx).pop();
                                                                  },
                                                                ),
                                                                Button(
                                                                  child: const Text('إلغاء'),
                                                                  onPressed: () {
                                                                    Navigator.of(ctx).pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          FilledButton(
                                              child: const Text('حفظ'),
                                              onPressed: () {
                                                if (_subjectController.text.isEmpty) {
                                                  showSnackbar(
                                                    context,
                                                    const Snackbar(
                                                      content: Text('الرجاء إدخال اسم المادة'),
                                                    ),
                                                  );
                                                  return;
                                                }
                                                SubjectModel subject = SubjectModel(
                                                  name: _subjectController.text,
                                                  color: provider.currentColor,
                                                );
                                                provider.addToSubjects(subject);
                                                _subjectController.clear();
                                                Navigator.pop(cnt);
                                              }),
                                          Button(
                                              child: const Text('الغاء'),
                                              onPressed: () {
                                                Navigator.pop(cnt);
                                              })
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        content: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                itemCount: provider.subjects.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Dismissible(
                                        key: UniqueKey(),
                                        onDismissed: (_) {
                                          provider.removeFromSubjects(index);
                                        },
                                        child: ListTile(
                                          title: Text(provider.subjects[index].name!),
                                          leading: CircleAvatar(
                                            backgroundColor: provider.subjects[index].color!,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, int index) {
                                  return const Divider();
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: FilledButton(
                                        child: const Text('إنهاء'),
                                        onPressed: () async {
                                          if (provider.subjects.isEmpty) {
                                            showSnackbar(
                                              context,
                                              const Snackbar(
                                                content: Text('عليك إضافة مادة واحدة على الأقل'),
                                              ),
                                            );
                                            return;
                                          }

                                          List subjects = provider.subjects
                                              .map((e) => {
                                                    'name': e.name,
                                                    'color': e.color!.value,
                                                  })
                                              .toList();

                                          Map initialSetupData = {
                                            'lecturesCount': provider.lecturesCount,
                                            'days': provider.getCheckedDays(),
                                            'subjects': subjects
                                          };

                                          final prefs = await SharedPreferences.getInstance();
                                          await prefs.setBool('isFirstTime', false);
                                          await prefs.setString('appData', jsonEncode(initialSetupData));
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: FilledButton(
                                        child: const Text('السابق'),
                                        onPressed: () {
                                          provider.setCurrentIndex = 1;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
