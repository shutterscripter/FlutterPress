import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:news_app/components/BlogTile.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/services/api_services.dart';
import 'package:news_app/utils/color_utils.dart';

class CategoryNewsScreen extends StatefulWidget {
  String name;

  CategoryNewsScreen({super.key, required this.name});

  @override
  State<CategoryNewsScreen> createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends State<CategoryNewsScreen> {
  List<ArticleModel> categoryArticleList = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    getArticleByCat();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      color: Colors.grey,
      height: 300,
      backgroundColor: Colors.white,
      showChildOpacityTransition: false,
      onRefresh: () async {
        await getArticleByCat();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          //add back button
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: ColorUtils().purple),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              Image.asset(
                'assets/news_summary_banner.png',
                height: 40,
              ),
              Expanded(
                child: Text(
                  " - ${widget.name}",
                  style: TextStyle(
                    color: ColorUtils().purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: _loading
            ? ListView.builder(
                itemCount: categoryArticleList.length,
                itemBuilder: (context, index) {
                  if (categoryArticleList[index].imageUrl == null ||
                      categoryArticleList[index].title == null ||
                      categoryArticleList[index].description == null) {
                    // If any of the required fields is null, return an empty container
                    return Container();
                  }

                  return BlogTile(
                    source: categoryArticleList[index].source ?? "No Source",
                    imageUrl: categoryArticleList[index].imageUrl ?? '',
                    title: categoryArticleList[index].title ?? "No Title",
                    desc: categoryArticleList[index].description ??
                        "No Description",
                    url: categoryArticleList[index].url!,
                    publishedAt: categoryArticleList[index].publishedAt ?? '',
                    author: categoryArticleList[index].author ?? "No Author",
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future<void> getArticleByCat() async {
    ApiService client = ApiService();
    await client.getArticleByCategory(widget.name.toLowerCase());
    categoryArticleList = client.categoryArticleList;

    setState(() {
      _loading = true;
    });
  }
}
