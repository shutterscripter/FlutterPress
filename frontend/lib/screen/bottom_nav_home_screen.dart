import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:news_app/screen/fav_news.dart';
import 'package:news_app/app/home/first_screen.dart';
import 'package:news_app/screen/settings_screen.dart';

class BottomNavHomeScreen extends StatefulWidget {
  const BottomNavHomeScreen({super.key});

  @override
  State<BottomNavHomeScreen> createState() => _BottomNavHomeScreenState();
}

class _BottomNavHomeScreenState extends State<BottomNavHomeScreen> {
  final NavigationController navigationController =
      Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Obx(
        () => NavigationBar(
          backgroundColor: Colors.white,
          height: 70,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          elevation: 3,

          selectedIndex: navigationController.selectedIndex.value,
          onDestinationSelected: (int index) =>
              navigationController.selectedIndex.value = index,
          destinations: [
            NavigationDestination(
                icon: Icon(
                  Iconsax.home,
                  size: 20,
                ),
                label: 'Home'),
            NavigationDestination(
                icon: Icon(
                  Iconsax.bookmark,
                  size: 20,
                ),
                label: 'Bookmark'),
            NavigationDestination(
                icon: Icon(
                  Iconsax.search_normal,
                  size: 20,
                ),
                label: 'Search'),
            NavigationDestination(
                icon: Icon(
                  Iconsax.notification,
                  size: 20,
                ),
                label: 'Notification'),
            NavigationDestination(
                icon: Icon(
                  Iconsax.setting,
                  size: 20,
                ),
                label: 'Settings'),
          ],
        ),
      ),
      body: Obx(() => navigationController
          .screens[navigationController.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    FirstScreen(),
    FavNews(),
    Container(color: Colors.blue),
    Container(color: Colors.yellow),
    SettingsScreen()

  ];
}
