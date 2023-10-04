import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:news_app/components/BlogTile.dart';
import 'package:news_app/components/category_tile.dart';
import 'package:news_app/components/custom_alert_dialog.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/screen/category_news_screen.dart';
import 'package:news_app/services/api_services.dart';
import 'package:news_app/services/data.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<ArticleModel> articleList = [];
  List<CategoryModel> categories = [];
  bool _loading = false;

  @override
  void initState() {
    categories = getCategories();
    getData();
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
                await getData();
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
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
                        child: const Icon(
                          Icons.search,
                          color: Colors.blue,
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
                    flexibleSpace: const FlexibleSpaceBar(
                      centerTitle: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Flutter",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Press",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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

  Future<void> getData() async {
    ApiService client = ApiService();
    await client.getArticle();
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
}
