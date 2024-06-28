import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/components/permission_controller.dart';
import 'package:news_app/screen/first_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  PermissionController _permissionController = Get.put(PermissionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/earth_globe.jpg",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            height: double.infinity,
            width: double.infinity,
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 200,
                  width: 200,
                ),

                //create a text widget align at the bottom of screen
                const Spacer(),
                Column(
                  children: [
                    const Text(
                      "Your Daily Digest",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Trustworthy news from reputable \npublications.",
                      //align text to center
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    const SizedBox(height: 70),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 120, vertical: 15),
                      ),
                      onPressed: () async {
                        // Set the flag to indicate that the landing page has been shown
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('firstLaunch', false);

                        ///Get Location
                        // await _permissionController
                        //     .checkLocationPermissionAndGrant();

                        // Navigate to the main screen
                        Get.off(
                          FirstScreen(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: const Text("Get Started"),
                    ),
                    const SizedBox(height: 50),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "By continuing you agree to our ",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Terms of Services.",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 7),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "For more information, see our ",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Privacy Policy.",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
