import 'package:fluent_ui/fluent_ui.dart';
import 'package:student_schedule/model/subject_model.dart';

class InitialSetupViewModel with ChangeNotifier {
  int currentIndex = 0;

  set setCurrentIndex(int newValue) {
    currentIndex = newValue;
    notifyListeners();
  }

  int radioIndex = 0;

  set setRadioIndex(int newValue) {
    radioIndex = newValue;
    notifyListeners();
  }

  int lecturesCount = 0;

  set setLecturesCount(int value){
    lecturesCount = value;
    notifyListeners();
  }

  Map weekDays = {
    0: {
      'name': 'السبت',
      'isChecked': true,
    },
    1: {
      'name': 'الأحد',
      'isChecked': true,
    },
    2: {
      'name': 'الاثنين',
      'isChecked': true,
    },
    3: {
      'name': 'الثلاثاء',
      'isChecked': true,
    },
    4: {
      'name': 'الاربعاء',
      'isChecked': true,
    },
    5: {
      'name': 'الخميس',
      'isChecked': true,
    },
    6: {
      'name': 'الجمعة',
      'isChecked': true,
    },
  };

  void setWeekDayCheckedValue(index,newValue){
    weekDays[index]['isChecked'] = newValue;
    notifyListeners();
  }

  List getCheckedDays(){
    List result = [];
    weekDays.forEach((key, value){
      if(value['isChecked'] == true){
        result.add(value['name']);
      }
    });
    return result;
  }


  List<SubjectModel> subjects = [];
  void addToSubjects(SubjectModel subject){
    subjects.add(subject);
    notifyListeners();
  }
  void removeFromSubjects(int index){
    subjects.removeAt(index);
    notifyListeners();
  }

  Color pickerColor =const Color(0xff0078d4);
  Color currentColor =const Color(0xff0078d4);

  set setPickerColor(Color color){
    pickerColor = color;
    notifyListeners();
  }

  set setCurrentColor(Color color){
    currentColor = color;
    notifyListeners();
  }

}
