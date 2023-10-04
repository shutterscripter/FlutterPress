import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screen/article_view.dart';

class BlogTile extends StatelessWidget {
  String imageUrl, title, desc, url, publishedAt;

  BlogTile(
      {super.key,
      required this.desc,
      required this.publishedAt,
      required this.imageUrl,
      required this.title,
      required this.url});

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(publishedAt);

    // Determine if the parsed date is today or tomorrow
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));
    print(publishedAt);

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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticleView(url: url)));
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
                            title,
                            maxLines: 3,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, top: 10),
                        child: Row(
                          children: [
                            //insert dotted icon
                            Icon(
                              Icons.circle,
                              size: 7,
                              color: Colors.grey.shade400,
                            ),
                            Icon(
                              Icons.circle,
                              size: 7,
                              color: Colors.grey.shade400,
                            ),
                            Icon(
                              Icons.circle,
                              size: 7,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
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
