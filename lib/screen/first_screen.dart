import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:news_app/components/BlogTile.dart';
import 'package:news_app/components/category_tile.dart';
import 'package:news_app/components/custom_alert_dialog.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/screen/category_news_screen.dart';
import 'package:news_app/screen/fav_news.dart';
import 'package:news_app/screen/settings_screen.dart';
import 'package:news_app/services/api_services.dart';
import 'package:news_app/services/data.dart';
import 'package:news_app/utils/color_utils.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final ApiService client = Get.put(ApiService());
  List<ArticleModel> articleList = [];
  List<CategoryModel> categories = [];
  List<String> userLocations = [];
  double? lat;
  double? long;
  String address = "";
  bool _loading = false;

  @override
  void initState() {
    categories = getCategories();
    getLatLong();
    print("LAT $lat LONG $long ADDRESS $address");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? LiquidPullToRefresh(
              color: Colors.grey,
              height: 300,
              backgroundColor: Colors.white,
              showChildOpacityTransition: false,
              onRefresh: () async {
                await getLatLong();
                setState(() {
                  _loading = true;
                });
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    actions: [
                      IconButton(
                        onPressed: () {
                          ///navigate to settings screen
                          Get.to(SettingsScreen(),
                              transition: Transition.rightToLeft);
                        },
                        icon: Icon(
                          Icons.menu_rounded,
                          size: 30,
                          color: ColorUtils().purple,
                        ),
                      ),
                    ],
                    leading: InkWell(
                      onTap: () {
                        _showDialog(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 5, top: 5),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[200],
                        ),
                        child: Icon(
                          Icons.search,
                          color: ColorUtils().purple,
                          size: 25,
                        ),
                      ),
                    ),
                    centerTitle: true,
                    elevation: 0,
                    expandedHeight: 60,
                    backgroundColor: Colors.transparent,
                    floating: false,
                    pinned: false,
                    title: Image.asset(
                      'assets/news_summary_banner.png',
                      height: 40,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryNewsScreen(
                                      name:
                                          categories[index].categoryName ?? ''),
                                ),
                              );
                            },
                            child: CategoryTile(
                                categoryName:
                                    categories[index].categoryName ?? '',
                                image: categories[index].image ?? ''),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return BlogTile(
                          imageUrl: articleList[index].imageUrl ??
                              'https://www.brasscraft.com/wp-content/uploads/2017/01/no-image-available.png',
                          title: articleList[index].title ?? '',
                          desc: articleList[index].description ?? '',
                          url: articleList[index].url ?? '',
                          publishedAt: articleList[index].publishedAt ?? '',
                        );
                      },
                      childCount: articleList.length,
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<void> getData(List<String> locations) async {
    await client.getArticle(locations);
    articleList = client.articleList;
    setState(() {
      _loading = true;
    });
  }

  Future<void> _showDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomAlertDialog(); // CustomDialog is the StatefulWidget we created earlier
      },
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print("Location services are disabled.");
      // ask user to enable location services
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable location services(GPS).'),
        ),
      );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) {
      print("value $value");
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });

      getAddress(value.latitude, value.longitude);
    }).catchError((error) {
      print("Error $error");
    });
  }

//For convert lat long to address
  getAddress(lat, long) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, long);
    setState(() {
      address = placeMarks[0].street! + " " + placeMarks[0].country!;
    });

    Set<String> locationsForNews = {};
    for (int i = 0; i < placeMarks.length; i++) {
      print("INDEX $i ${placeMarks[i]}");
      locationsForNews.add(placeMarks[i].locality!);
      locationsForNews.add(placeMarks[i].subAdministrativeArea!);
    }
    print("LOCATIONS: $locationsForNews");
    //convert set to list
    userLocations = locationsForNews.toList();
    await getData(userLocations);
  }
}
