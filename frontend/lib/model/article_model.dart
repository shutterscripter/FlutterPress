import 'package:news_app/model/source_model.dart';

class ArticleModel {
  final String? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? imageUrl;
  final String? publishedAt;
  final String? content;

  ArticleModel({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.imageUrl,
    this.publishedAt,
    this.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      source: json['source']['name'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      url: json['url'],
      imageUrl: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }
}
