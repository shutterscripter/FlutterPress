import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:get/get.dart';
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
                  expandedHeight: 400.h,
                  floating: false,
                  pinned: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  leading: Container(
                    margin: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        widget.articleModel.imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: widget.articleModel.imageUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant),
                                errorWidget: (context, url, error) => Container(
                                    color: Colors.grey.shade200,
                                    child: Icon(Icons.error)),
                              )
                            : Container(color: Colors.grey.shade200),
                        // Gradient Overlay for text readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.2),
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                        // Title on Image (Editorial Style)
                        Positioned(
                          bottom: 20.h,
                          left: 20.w,
                          right: 20.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  widget.articleModel.source ?? 'News',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                widget.articleModel.title ?? 'No Title',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 4.0,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Article Content
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30.r)),
                    ),
                    transform: Matrix4.translationValues(0, -20, 0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 30.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Metadata Row
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16.r,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                child: Icon(Icons.person,
                                    size: 18.sp,
                                    color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.articleModel.author ?? 'News Desk',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                    ),
                                  ),
                                  Text(
                                    _formatDate(
                                        widget.articleModel.publishedAt ?? ""),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              // IconButton(
                              //   icon: Icon(Iconsax.copy),
                              //   onPressed: () {}, // TODO: Copy functionality
                              // ),
                            ],
                          ),

                          SizedBox(height: 30.h),

                          // AI Summary Section
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Theme.of(context)
                                    .dividerColor
                                    .withOpacity(0.1),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.articleModel.description ??
                                      'No description available',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    height: 1.6,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 120.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Floating Action Bar
            Align(
              alignment: Alignment.bottomCenter,
              child: ScrollToHide(
                height: 100.h,
                scrollController: _scrollController,
                hideDirection: Axis.vertical,
                child: Container(
                  margin:
                      EdgeInsets.only(bottom: 40.h, left: 24.w, right: 24.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bookmark
                      _buildActionButton(
                        context: context,
                        icon: Iconsax.bookmark,
                        isActive: _bookmarkController.isBookmarked.value,
                        onTap: () => _handleBookmark(),
                      ),

                      // SizedBox(width: 16.w),

                      // Share
                      // _buildActionButton(
                      //   context: context,
                      //   icon: Iconsax.share,
                      //   onTap: () => _handleShare(),
                      // ),

                      SizedBox(width: 16.w),

                      // Read Full Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(
                              ArticleView(
                                url: widget.articleModel.url ?? "",
                                desc: widget.articleModel.description ?? "",
                              ),
                              transition: Transition.rightToLeft,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Read Full Article',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
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
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Theme.of(context).scaffoldBackgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive
              ? Theme.of(context).primaryColor
              : Theme.of(context).iconTheme.color,
          size: 24.sp,
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
          ? "Removed from bookmarks"
          : "Saved to bookmarks",
    );
    setState(() {}); // Refresh to update icon state
  }

  void _handleShare() {
    // TODO: Implement share functionality
    CustomSnackBar.showInfo(
      context: context,
      message: "Share feature coming soon",
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return "${date.day} ${_getMonth(date.month)}, ${date.year}";
    } catch (e) {
      return "";
    }
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
