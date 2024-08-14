import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:news_app/app/home/home_screen_controller.dart';
import 'package:news_app/components/BlogTile.dart';
import 'package:news_app/components/category_tile.dart';
import 'package:news_app/constants/image_constants.dart';
import 'package:news_app/screen/category_news_screen.dart';
import 'package:news_app/services/api_services.dart';
import 'package:news_app/services/data.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController());

  @override
  void initState() {
    _homeScreenController.categories = getCategories();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: Image.asset(ImageConstants.menuIcon),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'News',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              Text(
                'App',
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<HomeScreenController>(
        builder: (value) => _homeScreenController.loading
            ? LiquidPullToRefresh(
                color: Colors.grey,
                height: 300,
                backgroundColor: Colors.white,
                showChildOpacityTransition: false,
                onRefresh: () async {
                  await getData();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _homeScreenController.categories.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryNewsScreen(
                                        name: _homeScreenController
                                                .categories[index]
                                                .categoryName ??
                                            ''),
                                  ),
                                );
                              },
                              child: CategoryTile(
                                  categoryName: _homeScreenController
                                          .categories[index].categoryName ??
                                      '',
                                  image: _homeScreenController
                                          .categories[index].image ??
                                      ''),
                            );
                          },
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return BlogTile(
                            source: _homeScreenController
                                    .articleList[index].source ??
                                '',
                            imageUrl: _homeScreenController
                                    .articleList[index].imageUrl ??
                                'https://www.brasscraft.com/wp-content/uploads/2017/01/no-image-available.png',
                            title: _homeScreenController
                                    .articleList[index].title ??
                                '',
                            desc: _homeScreenController
                                    .articleList[index].description ??
                                '',
                            url: _homeScreenController.articleList[index].url ??
                                '',
                            publishedAt: _homeScreenController
                                    .articleList[index].publishedAt ??
                                '',
                            author: _homeScreenController
                                    .articleList[index].author ??
                                '',
                          );
                        },
                        childCount: _homeScreenController.articleList.length,
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future<void> getData() async {
    ApiService client = ApiService();
    await client.getArticle();
    _homeScreenController.articleList = client.articleList;
    _homeScreenController.loading = true;
    _homeScreenController.update();
  }
}
