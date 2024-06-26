import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/controller/theme_support.dart';
import 'package:news_app/dependency_injection.dart';
import 'package:news_app/screen/first_screen.dart';
import 'package:news_app/screen/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('firstLaunch') ?? true;

  DependencyInjection.init();

  //Hive related code
  await Hive.initFlutter();
  await Hive.openBox('MyNews');

  runApp(
    MyApp(
      isFirstLaunch: isFirstLaunch,
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isFirstLaunch;

  const MyApp({super.key, required this.isFirstLaunch});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeSupport.lightTheme,
      darkTheme: ThemeSupport.darkTheme,
      themeMode: ThemeMode.light,
      home: widget.isFirstLaunch ? const LandingPage() : const FirstScreen(),
      // home:  const LandingPage() ,
    );
  }
}
