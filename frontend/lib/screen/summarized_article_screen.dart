import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
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
                            image: NetworkImage(
                                widget.articleModel.imageUrl ?? ""),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.0.h,
                          left: 30.0.w,
                          right: 30.0.w,
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
                              DateTime.parse(
                                          widget.articleModel.publishedAt ?? "")
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
                              widget.articleModel.description ??
                                  'No description',
                              style: TextStyle(
                                fontSize: 18.sp,
                                wordSpacing: 1,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),

                            ///swipe left to view full article
                            Container(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Swipe left to view full article",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // back button
                  Positioned(
                    top: 40.h,
                    left: 20.w,
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
            Positioned(
              bottom: 20.h,
              right: 100.w,
              left: 100.w,
              height: 50.w,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Iconsax.bookmark,
                        color: Colors.grey,
                        size: 25.sp,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Iconsax.share,
                        color: Colors.grey,
                        size: 25.sp,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
