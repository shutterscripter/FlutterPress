import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/app/auth/auth_controller.dart';
import 'package:news_app/app/auth/login_screen.dart';
import 'package:news_app/controller/theme_support.dart';

import 'package:news_app/screen/bottom_nav_home_screen.dart';
import 'package:news_app/screen/landing_page.dart';
import 'package:news_app/services/api_services.dart';
import 'package:news_app/utils/flex_color_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/initial_binding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zkfidlxtrvkzwplhrkld.supabase.co',
    anonKey: 'sb_publishable_ZippgTLEC30A_udUNyQTZQ_PSL-T_s_',
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('firstLaunch') ?? true;
  await ScreenUtil.ensureScreenSize();

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cache = DefaultCacheManager();
    final supabase = Supabase.instance.client;
    cache.emptyCache();
    ScreenUtil.init(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: supabase.auth.currentSession != null
          ? BottomNavHomeScreen()
          : LoginScreen(),
    );
  }
}
