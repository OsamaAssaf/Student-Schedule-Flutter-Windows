import 'package:fluent_ui/fluent_ui.dart';

class SplashViewModel with ChangeNotifier{

  bool? isFirstTime;
  set setIsFirstTime(bool value){
    isFirstTime = value;
    notifyListeners();
  }

}