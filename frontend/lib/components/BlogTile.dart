import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/app/bookmark/boomark_controller.dart';
import 'package:news_app/app/home/home_screen_controller.dart';
import 'package:news_app/core/summarization/summarize_controller.dart';
import 'package:news_app/model/article_model.dart';
import 'package:hive/hive.dart';
import 'package:news_app/screen/summarized_article_screen.dart';

class BlogTile extends StatefulWidget {
  final String imageUrl, title, desc, url, publishedAt, source, author;

  const BlogTile(
      {super.key,
      required this.source,
      required this.desc,
      required this.publishedAt,
      required this.imageUrl,
      required this.title,
      required this.url,
      required this.author});

  @override
  State<BlogTile> createState() => _BlogTileState();
}

class _BlogTileState extends State<BlogTile> {
  final SummarizeController _summarizeController =
      Get.put(SummarizeController());
  final _favoritesController = Get.put(BookmarkController());
  bool isSummarized = false;
  var summarizationWordsNumbers = 200;

  @override
  Widget build(BuildContext context) {
    Color _color = Colors.grey.shade400;
    DateTime parsedDate = DateTime.parse(widget.publishedAt);

    // Determine if the parsed date is today or tomorrow
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));

    String result;

    bool isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    if (isSameDay(parsedDate, today)) {
      result = 'Today';
    } else if (isSameDay(parsedDate, tomorrow)) {
      result = 'Tomorrow';
    } else {
      // If it's not today or tomorrow, you can format the date as desired
      result = '${parsedDate.day}-${parsedDate.month}-${parsedDate.year}';
    }

    return GestureDetector(
      onTap: () async {
        _summarizeController.summarizeArticle(
            context,
            widget.title,
            widget.desc,
            widget.url,
            widget.imageUrl,
            widget.publishedAt,
            widget.author);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                height: 90.h,
                width: 95.w,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article Source
                  Text(
                    '${widget.source}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                  // Article Title
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      widget.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
