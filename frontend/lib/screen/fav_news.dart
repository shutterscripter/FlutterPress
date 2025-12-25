import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:news_app/components/BlogTile.dart';

class FavNews extends StatefulWidget {
  const FavNews({super.key});

  @override
  State<FavNews> createState() => _FavNewsState();
}

class _FavNewsState extends State<FavNews> {
  final _box = Hive.box('MyNews');
  var list;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Saved Stories',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Show info or clear all logic
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Saved Articles',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Text(
                      'Swipe left on an article to remove it from your bookmarks.'),
                  actions: [
                    TextButton(
                      child: Text('Understood'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Iconsax.info_circle, size: 24.sp),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('MyNews').listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.bookmark,
                    size: 64.sp,
                    color: Theme.of(context).disabledColor,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No saved articles yet',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Theme.of(context).disabledColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Tap the bookmark icon on any\narticle to save it here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).disabledColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          var list = box.values.toList();

          return AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
              itemCount: list.length,
              itemBuilder: (context, index) {
                // Reverse index to show newest first
                final reversedIndex = list.length - 1 - index;
                final article = list[reversedIndex];

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Dismissible(
                        key: Key(article['title'] ?? DateTime.now().toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.w),
                          color: Colors.redAccent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.trash, color: Colors.white),
                              SizedBox(height: 4.h),
                              Text(
                                "Remove",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          box.deleteAt(reversedIndex);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Article removed from bookmarks'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          );
                        },
                        child: BlogTile(
                          imageUrl: article['urlToImage'] ?? '',
                          title: article['title'] ?? '',
                          desc: article['desc'] ?? '',
                          url: article['url'] ?? '',
                          publishedAt: article['publishedAt'] ?? '',
                          source: article['source'] ?? '',
                          author: article['author'] ?? '',
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void getData() {
    // Logic moved to ValueListenableBuilder for reactive updates
    // Keeping this method if parent requires it, or just to satisfy override if applicable
    list = _box.values.toList();
  }
}
