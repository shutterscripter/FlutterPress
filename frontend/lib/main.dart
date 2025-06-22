import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/app/auth/auth_controller.dart';
import 'package:news_app/app/auth/login_screen.dart';
import 'package:news_app/controller/theme_support.dart';
import 'package:news_app/dependency_injection.dart';
import 'package:news_app/screen/bottom_nav_home_screen.dart';
import 'package:news_app/screen/landing_page.dart';
import 'package:news_app/utils/flex_color_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('firstLaunch') ?? true;
  await ScreenUtil.ensureScreenSize();
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
  AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cache = DefaultCacheManager();
    cache.emptyCache();
    ScreenUtil.init(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: FutureBuilder<Widget>(
        future: _checkLoginState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('Error loading app'),
              ),
            );
          }

          return snapshot.data ?? const LoginScreen();
        },
      ),
    );
  }

  // Check login state
  Future<Widget> _checkLoginState() async {
    try {
      bool? isLoggedIn = await _authController.getLogin();

      if (isLoggedIn == true) {
        // User is logged in - go to home
        return const BottomNavHomeScreen();
      } else {
        // User is not logged in - go to login
        return const LoginScreen();
      }
    } catch (e) {
      print('Error checking login state: $e');
      return const LoginScreen();
    }
  }
}
