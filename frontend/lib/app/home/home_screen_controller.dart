// ignore: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/consts.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/constants/api_constants.dart';
import 'package:news_app/app/auth/auth_controller.dart';
import 'package:news_app/components/custom_snackbar.dart';

class HomeScreenController extends GetxController {
  Color bookmarkedIconColor = Colors.grey.shade400;
  bool loading = false;
  List<ArticleModel> articleList = [];
  List<CategoryModel> categories = [];
  final AuthController _authController = Get.find<AuthController>();

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

  Future<String?> summarizeNews(String newsArticle) async {
    try {
      // Show loading snackbar
      CustomSnackBar.showLoading(
          context: Get.context!, message: 'Summarizing article...');

      // Get authorization headers
      Map<String, String> headers = await _authController.getAuthHeaders();

      // Prepare request body
      var requestBody = {'text': newsArticle};

      // Make API call
      var response = await http.post(
        Uri.parse(ApiConstants.summarizeNews),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Hide loading snackbar
      CustomSnackBar.hideCurrent(Get.context!);

      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        try {
          var responseData = jsonDecode(response.body);

          // Extract summary from response (adjust based on your API response structure)
          String? summary = responseData['summary'] ??
              responseData['text'] ??
              responseData['result'];

          if (summary != null) {
            // CustomSnackBar.showSuccess(
            //     context: Get.context!,
            //     message: 'Article summarized successfully!');
            loading = false;
            print(summary);
            return summary;
          } else {
            CustomSnackBar.showError(
                context: Get.context!, message: 'Invalid response format');
            return null;
          }
        } catch (parseError) {
          CustomSnackBar.showError(
              context: Get.context!,
              message: 'Error parsing response: $parseError');
          return null;
        }
      } else {
        CustomSnackBar.showError(
            context: Get.context!,
            message: 'Summarization failed: ${response.body}');
        return null;
      }
    } catch (e) {
      CustomSnackBar.hideCurrent(Get.context!);
      CustomSnackBar.showError(
          context: Get.context!, message: 'Network error: $e');
      return null;
    }
  }
}
