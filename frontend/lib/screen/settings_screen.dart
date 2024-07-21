import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                'Dark Mode',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Switch(
                value: darkMode,
                activeColor: ColorUtils.purp,
                inactiveThumbColor: Colors.grey,
                onChanged: (value) {
                  setState(() {
                    darkMode = !darkMode;
                  });
                },
              ),
            ),
            Divider(
              height: 20,
              endIndent: 20,
              indent: 20,
              color: Colors.grey,
            ),
            ListTile(
              title: const Text(
                'Notification',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
            Divider(
              height: 20,
              endIndent: 20,
              indent: 20,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {
                //navigate to fav news screen
                Get.to(FavNews(), transition: Transition.rightToLeft);
              },
              title: const Text(
                'Favourite News',
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
            Spacer(),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            //made with love
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Made with ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Icon(
                    Icons.favorite,
                    size: 13,
                    color: Colors.red,
                  ),
                  Text(
                    ' by ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Shutter Scripter',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
