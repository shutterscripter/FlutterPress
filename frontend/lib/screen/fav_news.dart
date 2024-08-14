import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/components/BlogTile.dart';
import 'package:news_app/screen/article_view.dart';

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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Bookmarks",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          //info button telling user how to remove the article
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Remove an article",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      "Swipe left on an article to remove it from the list",
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.info,
              size: 20.sp,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              //open the article in a web view
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleView(
                    url: list[index]['url'],
                    desc: list[index]['desc'],
                  ),
                ),
              );
            },
            child: Dismissible(
              background: Container(
                color: Colors.red,
                child: Center(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Remove",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
              key: Key(list[index]['title']),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                //remove the article from the list
                _box.deleteAt(index);
                getData();
              },
              child: BlogTile(
                imageUrl: list[index]['urlToImage'] ?? '',
                title: list[index]['title'] ?? '',
                desc: list[index]['desc'] ?? '',
                url: list[index]['url'] ?? '',
                publishedAt: list[index]['publishedAt'] ?? '',
                source: list[index]['source'] ?? '',
                author: list[index]['author'] ?? '',
              ),
            ),
          );
        },
      ),
    );
  }

  void getData() {
    //get all the data and store it in a list
    list = _box.values.toList();
    setState(() {});
  }
}
