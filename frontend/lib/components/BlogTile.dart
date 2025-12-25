import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ml_text_summarizer/ml_text_summarizer.dart';
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

  final summarizer = TextSummarizer(
    maxSentences: 24,
    language: 'en', // or 'tr' for Turkish
  );

  @override
  Widget build(BuildContext context) {
    Color _color = Colors.grey.shade400;
    DateTime parsedDate = DateTime.parse(widget.publishedAt);

    // Determine if the parsed date is today or tomorrow
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));

    String formattedDate;

    bool isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    if (isSameDay(parsedDate, today)) {
      formattedDate = 'Today';
    } else if (isSameDay(parsedDate, tomorrow)) {
      formattedDate = 'Tomorrow';
    } else {
      formattedDate =
          '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    }

    return GestureDetector(
      onTap: () async {
        String summary = summarizer.summarize(widget.desc);

        // Clean up the summary
        summary = summary.trim();
        if (summary.endsWith('…') || summary.endsWith('...')) {
          summary = summary.substring(
              0, summary.length - (summary.endsWith('...') ? 3 : 1));
        }

        // Remove incomplete last sentence if it doesn't end with punctuation
        if (summary.isNotEmpty && !RegExp(r'[.!?]$').hasMatch(summary)) {
          int lastDot = summary.lastIndexOf('.');
          if (lastDot != -1) {
            summary = summary.substring(0, lastDot + 1);
          }
        }

        print('Cleaned Summary: $summary');

        Get.to(SummarizedArticleScreen(
            articleModel: ArticleModel(
          title: widget.title,
          description: summary,
          url: widget.url,
          imageUrl: widget.imageUrl,
          publishedAt: widget.publishedAt,
          author: widget.author,
          source: widget.source,
        )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article Image
              Hero(
                tag: widget.imageUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: widget.imageUrl == '404'
                      ? Container(
                          height: 90.h,
                          width: 90.w,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: Icon(Icons.image_not_supported,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant),
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          height: 90.h,
                          width: 90.w,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: Icon(Icons.error_outline),
                          ),
                        ),
                ),
              ),
              SizedBox(width: 16.w),
              // Content Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Source & Date Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              widget.source,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Title
                    Text(
                      widget.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
