import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:news_app/app/home/home_screen_controller.dart';
import 'package:news_app/components/BlogTile.dart';
import 'package:news_app/components/category_tile.dart';
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
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'News',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              Text(
                'App',
                style: TextStyle(
                  fontWeight: FontWeight.w200,
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
            ? RefreshIndicator(
                onRefresh: () async {
                  await getData();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(top: 10.h),
                        height: 80.h,
                        child: AnimationLimiter(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _homeScreenController.categories.length,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  horizontalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => CategoryNewsScreen(
                                              name: _homeScreenController
                                                      .categories[index]
                                                      .categoryName ??
                                                  ''),
                                          transition: Transition.native,
                                        );
                                      },
                                      child: CategoryTile(
                                          categoryName: _homeScreenController
                                                  .categories[index]
                                                  .categoryName ??
                                              '',
                                          image: _homeScreenController
                                                  .categories[index].image ??
                                              ''),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: BlogTile(
                                  source: _homeScreenController
                                          .articleList[index].source ??
                                      '',
                                  imageUrl: _homeScreenController
                                          .articleList[index].imageUrl ??
                                      '404',
                                  title: _homeScreenController
                                          .articleList[index].title ??
                                      '',
                                  desc: _homeScreenController
                                          .articleList[index].description ??
                                      '',
                                  url: _homeScreenController
                                          .articleList[index].url ??
                                      '',
                                  publishedAt: _homeScreenController
                                          .articleList[index].publishedAt ??
                                      '',
                                  author: _homeScreenController
                                          .articleList[index].author ??
                                      '',
                                ),
                              ),
                            ),
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
