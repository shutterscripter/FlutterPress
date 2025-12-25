import 'package:flutter/material.dart';

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
  final screens = [FirstScreen(), FavNews(), SettingsScreen()];
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).canvasColor,
        surfaceTintColor: Theme.of(context).canvasColor,
        indicatorColor: Theme.of(context).primaryColor.withValues(alpha: 0.4),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        elevation: 1,
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              Iconsax.home,
              size: 20,
            ),
            label: 'Home',
          ),
          NavigationDestination(
              icon: Icon(
                Iconsax.bookmark,
                size: 20,
              ),
              label: 'Bookmark'),
          NavigationDestination(
              icon: Icon(
                Iconsax.setting,
                size: 20,
              ),
              label: 'Settings'),
        ],
      ),
      body: screens[selectedIndex],
    );
  }
}
