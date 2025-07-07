import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/app/auth/auth_controller.dart';
import 'package:news_app/app/auth/login_screen.dart';
import 'package:news_app/screen/fav_news.dart';
import 'package:news_app/utils/color_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool notification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [




            ListTile(
              title: const Text(
                'Language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            Divider(
              height: 20,
              endIndent: 20,
              indent: 20,
              color: Colors.grey,
            ),
            ListTile(
              title: const Text(
                'Country',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            Divider(
              height: 20,
              endIndent: 20,
              indent: 20,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {
                // Log out logic
                final authController = Get.put(AuthController());
                authController.logout();
                Get.offAll(()=> LoginScreen(), transition: Transition.rightToLeft);
              },
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),


          ],
        ),
      ),
    );
  }
}
