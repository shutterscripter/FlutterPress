import 'package:news_app/model/article_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ApiService {
  final cache = DefaultCacheManager();
  List<ArticleModel> articleList = [];
  List<ArticleModel> categoryArticleList = [];
  List<ArticleModel> searchArticleList = [];

  Future<void> getArticle() async {
    var res = await cache.getFileFromCache('article_list');

    if (res != null && res.file.existsSync()) {
      var jsonData = jsonDecode(res.file.readAsStringSync());
      if (jsonData is Map<String, dynamic> &&
          jsonData.containsKey('articles') &&
          jsonData['articles'] is List) {
        articleList = List<ArticleModel>.from(jsonData['articles']
            .map((article) => ArticleModel.fromJson(article)));
        print('Article List from cache: $articleList');
      }
    } else {
      const String urlExplore =
          "https://newsapi.org/v2/everything?q=india&language=en&sortBy=publishedAt&apiKey=465d0a5e15194833bee830c9366ebe72";

      var res = await http.get(Uri.parse(urlExplore));
      var jsonData = jsonDecode(res.body);
      if (jsonData['status'] == 'ok') {
        jsonData['articles'].forEach((element) {
          if (element['url'] != null && element['description'] != null) {
            ArticleModel articleModel = ArticleModel(
              source: element['source']['name'],
              title: element['title'],
              author: element['author'],
              description: element['description'],
              url: element['url'],
              imageUrl: element['urlToImage'],
              publishedAt: element['publishedAt'],
              content: element['content'],
            );
            cache.putFile('article_list', res.bodyBytes);
            articleList.add(articleModel);
            print("not cached");
          }
        });
      }
    }
  }

  Future<void> getArticleByCategory(String category) async {
    var catRes =
        await cache.getFileFromCache('category_article_list_$category');

    if (catRes != null && catRes.file.existsSync()) {
      var jsonData = jsonDecode(catRes.file.readAsStringSync());
      if (jsonData is Map<String, dynamic> &&
          jsonData.containsKey('articles') &&
          jsonData['articles'] is List) {
        categoryArticleList = List<ArticleModel>.from(jsonData['articles']
            .map((article) => ArticleModel.fromJson(article)));
        print('Category Article List from cache: $categoryArticleList');
      }
    } else {
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
            cache.putFile('category_article_list_$category', res.bodyBytes);
            categoryArticleList.add(articleModel);
          }
        });
      }
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
