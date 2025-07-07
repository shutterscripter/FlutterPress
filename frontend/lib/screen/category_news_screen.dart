import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
  final apiService = Get.put(ApiService());

  @override
  void initState() {
    super.initState();
    apiService.getArticleByCategory(widget.name.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ApiService>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "${widget.name}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
        ),
        body: controller.loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: ListView.builder(
                  itemCount: controller.categoryArticleList.length,
                  itemBuilder: (context, index) {
                    final article = controller.categoryArticleList[index];
                    if (article.imageUrl == null ||
                        article.title == null ||
                        article.description == null) {
                      return Container();
                    }
                    return BlogTile(
                      source: article.source ?? "No Source",
                      imageUrl: article.imageUrl ?? '',
                      title: article.title ?? "No Title",
                      desc: article.description ?? "No Description",
                      url: article.url ?? '',
                      publishedAt: article.publishedAt ?? '',
                      author: article.author ?? "No Author",
                    );
                  },
                ),
              ),
      ),
    );
  }
}
