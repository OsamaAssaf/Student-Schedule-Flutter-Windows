import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_schedule/view-model/splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
      if(isFirstTime){
        if (mounted){
          Provider.of<SplashViewModel>(context,listen: false).setIsFirstTime = true;
        }
      }else{
        if (mounted){
          Provider.of<SplashViewModel>(context,listen: false).setIsFirstTime = false;
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Center(
        child: Image.asset(
          'assets/images/icon.png',
          width: 180.0,
        ),
      ),
    );
  }
}
