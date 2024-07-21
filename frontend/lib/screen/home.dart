import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:news_app/components/BlogTile.dart';
import 'package:news_app/components/category_tile.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/services/api_services.dart';
import 'package:news_app/services/data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      body: Container(
        child: Column(
          children: [
            Container(
              height: 70,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return CategoryTile(
                      categoryName: categories[index].categoryName ?? '',
                      image: categories[index].image ?? '');
                },
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
            _loading
                ? Container(
                    child: LiquidPullToRefresh(
                      color: Colors.grey,
                      height: 300,
                      backgroundColor: Colors.white,
                      showChildOpacityTransition: false,
                      onRefresh: () async {
                        await getData();
                      },
                      child: ListView.builder(
                        itemCount: articleList.length,
                        itemBuilder: (context, index) {
                          if (articleList[index].imageUrl == null ||
                              articleList[index].title == null ||
                              articleList[index].description == null) {
                            // If any of the required fields is null, return an empty container
                            return Container();
                          }

                          return BlogTile(
                            source: articleList[index].source ?? '',
                            imageUrl: articleList[index].imageUrl ?? '',
                            title: articleList[index].title ?? "No Title",
                            desc: articleList[index].description ??
                                "No Description",
                            url: articleList[index].url!,
                            publishedAt: articleList[index].publishedAt ?? '',
                            author: articleList[index].author ?? "No Author",
                          );
                        },
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
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
}
