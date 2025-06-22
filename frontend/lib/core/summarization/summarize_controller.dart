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
      barrierDismissible: false, // Prevent dismiss by tapping outside
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    var summarizedArticle = await _homeScreenController.summarizeNews(desc);

    ArticleModel articleModel = ArticleModel(
      title: title,
      description: summarizedArticle,
      url: url,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      author: author,
    );

    // Dismiss the dialog using Navigator.pop(context)
    Navigator.of(context, rootNavigator: true).pop();

    // Now navigate to the summarized article screen
    Get.to(
      SummarizedArticleScreen(articleModel: articleModel),
      transition: Transition.native,
    );
  }
}
