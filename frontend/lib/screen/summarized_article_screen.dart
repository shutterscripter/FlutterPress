import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                    height: Get.height * 0.30.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(widget.articleModel.imageUrl ?? ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 30.0,
                      right: 30.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Author
                        Text(
                          '${widget.articleModel.author ?? 'Unknown'}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        //title
                        Text(
                          widget.articleModel.title ?? 'No Title',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 22.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        //published date
                        Text(
                          DateTime.parse(widget.articleModel.publishedAt ?? "")
                                  .toString()
                                  .substring(0, 10) +
                              " " +
                              DateTime.parse(
                                      widget.articleModel.publishedAt ?? "")
                                  .toString()
                                  .substring(11, 16),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),

                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 0.5,
                          height: 40.h,
                        ),

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
                      color: Color(0xff141E28),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
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
