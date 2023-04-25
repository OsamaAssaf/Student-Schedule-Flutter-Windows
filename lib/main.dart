import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_schedule/view-model/home_view_model.dart';
import 'package:student_schedule/view-model/initial-setup-view-model.dart';
import 'package:student_schedule/view-model/splash_view_model.dart';
import 'package:student_schedule/views/initial-setup-view.dart';
import 'package:student_schedule/views/home_view.dart';
import 'package:student_schedule/views/splash_view.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();
  // prefs.clear();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashViewModel>(
      create: (_) => SplashViewModel(),
      child: Consumer<SplashViewModel>(
        builder: (BuildContext context, SplashViewModel provider, _) {
          return FluentApp(
            debugShowCheckedModeBanner: false,
            locale: const Locale('ar', 'jo'),
            theme: ThemeData(brightness: Brightness.dark),
            home: ChangeNotifierProvider(
              create: (_) => HomeViewModel(),
              child: const HomeView(),
            ),
            // home: provider.isFirstTime == null
            //     ? const SplashView()
            //     : provider.isFirstTime!
            //         ? ChangeNotifierProvider(
            //             create: (_) => InitialSetupViewModel(),
            //             child: InitialSetupView(),
            //           )
            //         : ChangeNotifierProvider(
            //             create: (_) => HomeViewModel(),
            //             child: const HomeView(),
            //           ),
          );
        },
      ),
    );
  }
}
