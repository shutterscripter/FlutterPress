import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:news_app/components/BlogTile.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/services/api_services.dart';

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
            icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              const Text(
                "Flutter",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Press",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              Text(
                " - ${widget.name}",
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
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
                    imageUrl: categoryArticleList[index].imageUrl ?? '',
                    title: categoryArticleList[index].title ?? "No Title",
                    desc: categoryArticleList[index].description ??
                        "No Description",
                    url: categoryArticleList[index].url!,
                    publishedAt: categoryArticleList[index].publishedAt ?? '',
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
