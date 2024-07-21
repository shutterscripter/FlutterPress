import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/app/home/home_screen_controller.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/screen/summarized_article_screen.dart';

class SummarizeController extends GetxController {
  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController());

  /** !This method will display circular progress bar and navigate to summarized article screen*/
  Future<void> summarizeArticle(
      context, title, desc, url, imageUrl, publishedAt, author) async {
    // show circular progress indicator
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          width: 100,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    var summarizedArticle = await _homeScreenController.summarizeText(
        desc, "summarize this news article in ${desc.length * 0.30} words");

    ArticleModel articleModel = ArticleModel(
      title: title,
      description: summarizedArticle,
      url: url,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      author: author,
    );
    Get.back();
    Get.to(SummarizedArticleScreen(articleModel: articleModel),
        transition: Transition.zoom);
  }
}
