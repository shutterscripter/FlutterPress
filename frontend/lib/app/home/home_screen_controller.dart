// ignore: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/consts.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/model/category_model.dart';

class HomeScreenController extends GetxController {
  Color bookmarkedIconColor = Colors.grey.shade400;
  bool loading = false;
  List<ArticleModel> articleList = [];
  List<CategoryModel> categories = [];

  Future<String?> summarizeText(myText, howToSummarize) async {
    // ignore: avoid_print
    print("requesting to summarize text...");
    // {"contents":[{"parts":[{"text":"Write a story about a magic backpack"}]}]}
    var data = {
      "contents": [
        {
          "parts": [
            {"text": "$howToSummarize - $myText"}
          ]
        }
      ]
    };

    var url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$AI_STUDIO_API_KEY";
    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    // ignore: avoid_print
    print(response.body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      //ignore: avoid_print
      print(
          "Success: ${result['candidates'][0]['content']['parts'][0]['text']}");
      var summarizedText =
          result['candidates'][0]['content']['parts'][0]['text'];
      return summarizedText;
    }
    return null;
  }
}
