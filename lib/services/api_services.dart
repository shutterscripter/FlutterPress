import 'package:get/get.dart';
import 'package:news_app/model/article_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService extends GetxController {
  List<ArticleModel> articleList = [];
  List<ArticleModel> categoryArticleList = [];
  List<ArticleModel> searchArticleList = [];

  Future<void> getArticle(List<String> locations) async {
    String locationsForUrl = "";
    for(int i =0;i<locations.length;i++){
      locationsForUrl += locations[i];
      if(i != locations.length-1){
        locationsForUrl += " OR ";
      }
    }
    print("Locations for Search $locationsForUrl");
    final String urlExplore =
        "https://newsapi.org/v2/everything?q=${locationsForUrl}&language=en&sortBy=publishedAt&apiKey=465d0a5e15194833bee830c9366ebe72";

    var res = await http.get(Uri.parse(urlExplore));
    var jsonData = jsonDecode(res.body);
    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['url'] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            url: element['url'],
            imageUrl: element['urlToImage'],
            publishedAt: element['publishedAt'],
            content: element['content'],
          );
          articleList.add(articleModel);
        }
      });
    }
  }

  Future<void> getArticleByCategory(String category) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&language=en&category=$category&apiKey=465d0a5e15194833bee830c9366ebe72";
    var res = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(res.body);
    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['url'] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            url: element['url'],
            imageUrl: element['urlToImage'],
            publishedAt: element['publishedAt'],
            content: element['content'],
          );
          categoryArticleList.add(articleModel);
        }
      });
    }
  }

  Future<void> searchArticle(String keywords) async {
    String urlExplore =
        'https://newsapi.org/v2/everything?q=$keywords&language=en&sortBy=publishedAt&apiKey=465d0a5e15194833bee830c9366ebe72';

    var res = await http.get(Uri.parse(urlExplore));
    var jsonData = jsonDecode(res.body);
    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['url'] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            url: element['url'],
            imageUrl: element['urlToImage'],
            publishedAt: element['publishedAt'],
            content: element['content'],
          );
          searchArticleList.add(articleModel);
        }
      });
    }
  }
}
