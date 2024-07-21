import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:news_app/components/BlogTile.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/services/api_services.dart';

class SearchResult extends StatefulWidget {
  String name;

  SearchResult({super.key, required this.name});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List<ArticleModel> searchArticleList = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    getData(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      color: Colors.grey,
      height: 300,
      backgroundColor: Colors.white,
      showChildOpacityTransition: false,
      onRefresh: () async {
        await getData(widget.name);
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
                " - ${widget.name.capitalizeFirst}",
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: _loading
            ? ListView.builder(
                itemCount: searchArticleList.length,
                itemBuilder: (context, index) {
                  if (searchArticleList[index].imageUrl == null ||
                      searchArticleList[index].title == null ||
                      searchArticleList[index].description == null) {
                    // If any of the required fields is null, return an empty container
                    return Container();
                  }

                  return BlogTile(
                    source: searchArticleList[index].source ?? '',
                    imageUrl: searchArticleList[index].imageUrl ?? '',
                    title: searchArticleList[index].title ?? "No Title",
                    desc: searchArticleList[index].description ??
                        "No Description",
                    url: searchArticleList[index].url!,
                    publishedAt: searchArticleList[index].publishedAt ?? '',
                    author: searchArticleList[index].author ?? "No Author",
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future<void> getData(String keywords) async {
    ApiService client = ApiService();
    await client.searchArticle(keywords);
    searchArticleList = client.searchArticleList;
    setState(() {
      _loading = true;
    });
    print("length :+ ${searchArticleList.length}");
  }
}
