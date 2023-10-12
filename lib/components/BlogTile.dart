import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screen/article_view.dart';
import 'dart:io';
import 'package:hive/hive.dart';

class BlogTile extends StatefulWidget {
  String imageUrl, title, desc, url, publishedAt;

  BlogTile(
      {super.key,
      required this.desc,
      required this.publishedAt,
      required this.imageUrl,
      required this.title,
      required this.url});

  @override
  State<BlogTile> createState() => _BlogTileState();
}

class _BlogTileState extends State<BlogTile> {
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(url: widget.url)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              '${result.toString()} ${parsedDate.hour}:${parsedDate.minute}',
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(
                            widget.title,
                            maxLines: 3,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () async {
                          final box = Hive.box('MyNews');
                          if (box.containsKey(widget.url)) {
                            box.delete(widget.url);
                            setState(() {
                              _color = Colors.grey.shade400;
                            });
                            print("deleted from fav");
                          } else {
                            box.put(
                              widget.url,
                              {
                                'title': widget.title,
                                'desc': widget.desc,
                                'url': widget.url,
                                'imageUrl': widget.imageUrl,
                                'publishedAt': widget.publishedAt,
                              },
                            );
                            setState(() {
                              _color = Colors.red;
                            });
                            print("addded to fav");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 10),
                          child: Icon(
                            Icons.favorite,
                            size: 30,
                            color: _color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
