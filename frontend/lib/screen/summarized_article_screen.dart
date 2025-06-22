import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:news_app/app/bookmark/boomark_controller.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/screen/article_view.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:news_app/components/custom_snackbar.dart';

class SummarizedArticleScreen extends StatefulWidget {
  final ArticleModel articleModel;

  const SummarizedArticleScreen({super.key, required this.articleModel});

  @override
  State<SummarizedArticleScreen> createState() =>
      _SummarizedArticleScreenState();
}

class _SummarizedArticleScreenState extends State<SummarizedArticleScreen> {
  bool isBottomBarVisible = false;
  final ScrollController _scrollController = ScrollController();
  final BookmarkController _bookmarkController = Get.put(BookmarkController());

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            // Main Content
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar with Image
                SliverAppBar(
                  expandedHeight: Get.height * 0.35,
                  floating: false,
                  pinned: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  leading: Container(
                    margin: EdgeInsets.only(left: 16.w, top: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24.r),
                          bottomRight: Radius.circular(24.r),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.articleModel.imageUrl ?? "",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24.r),
                            bottomRight: Radius.circular(24.r),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Article Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.articleModel.title ?? 'No Title',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                            color: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.color,
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Author and Date Row
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 16.sp,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                widget.articleModel.author ?? 'Unknown Author',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Icon(
                              Icons.access_time,
                              size: 16.sp,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              _formatDate(
                                  widget.articleModel.publishedAt ?? ""),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        // Divider
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.grey.withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10.h),

                        // Summarized Content
                        Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.articleModel.description ??
                                'No description available',
                            style: TextStyle(
                              fontSize: 16.sp,
                              height: 1.3,
                              fontWeight: FontWeight.w400,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),



                        
                        SizedBox(height: 150.h), // Space for bottom bar
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Action Bar
            Align(
              alignment: Alignment.bottomCenter,
              child: ScrollToHide(
                height: 80.h,
                scrollController: _scrollController,
                hideDirection: Axis.vertical,
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 50.h,
                    left: 30.w,
                    right: 30.w,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Bookmark Button
                      _buildActionButton(
                        icon: Iconsax.bookmark,
                        label: 'Bookmark',
                        isActive: _bookmarkController.isBookmarked.value,
                        onTap: () => _handleBookmark(),
                      ),

                      // Share Button
                      _buildActionButton(
                        icon: Iconsax.share,
                        label: 'Share',
                        onTap: () => _handleShare(),
                      ),

                      // Read Full Article Button
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 16.w),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.to(
                                ArticleView(
                                  url: widget.articleModel.url ?? "",
                                  desc: widget.articleModel.description ?? "",
                                ),
                                transition: Transition.rightToLeft,
                              );
                            },
                            icon: Icon(Icons.article, size: 18.sp),
                            label: Text(
                              'Read Full',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  isActive ? Theme.of(context).primaryColor : Colors.grey[600],
              size: 22.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Theme.of(context).primaryColor
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBookmark() {
    Map<String, dynamic> articleData = {
      'urlToImage': widget.articleModel.imageUrl,
      'title': widget.articleModel.title,
      'desc': widget.articleModel.description,
      'url': widget.articleModel.url,
      'publishedAt': widget.articleModel.publishedAt,
      'source': widget.articleModel.source,
      'author': widget.articleModel.author,
    };

    _bookmarkController.toggleBookmark(
        widget.articleModel.title ?? "", articleData);

    CustomSnackBar.showSuccess(
      context: context,
      message: _bookmarkController.isBookmarked.value
          ? "Article bookmarked successfully!"
          : "Article removed from bookmarks",
    );
  }

  void _handleShare() {
    // TODO: Implement share functionality
    CustomSnackBar.showInfo(
      context: context,
      message: "Share feature coming soon!",
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return "Unknown date";
    }
  }
}
