import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:get/get.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/screen/article_view.dart';

class SummarizedArticleScreen extends StatefulWidget {
  final ArticleModel articleModel;

  const SummarizedArticleScreen({super.key, required this.articleModel});

  @override
  State<SummarizedArticleScreen> createState() =>
      _SummarizedArticleScreenState();
}

class _SummarizedArticleScreenState extends State<SummarizedArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
      onSwipeLeft: (offset) {
        Get.to(
          ArticleView(
            url: widget.articleModel.url ?? "",
            desc: widget.articleModel.description ?? "",
          ),
          transition: Transition.rightToLeft,
        );
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //image
                  Container(
                    height: Get.height * 0.35,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(widget.articleModel.imageUrl ?? ""),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //title
                        Text(
                          widget.articleModel.title ?? "",
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        /// summarized content
                        Text(
                          widget.articleModel.description ?? 'No description',
                          style: const TextStyle(
                            fontSize: 18,
                            wordSpacing: 1,
                            letterSpacing: 1.5,
                            color: Colors.black,
                          ),
                        ),

                        ///swipe left to view full article
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Swipe left to view full article",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // back button
              Positioned(
                top: 40,
                left: 20,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(109, 255, 255, 255),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
